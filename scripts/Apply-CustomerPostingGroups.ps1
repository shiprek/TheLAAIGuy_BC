param(
    [Parameter(Mandatory = $true)][string] $Tenant,
    [Parameter(Mandatory = $true)][string] $ClientId,
    [Parameter(Mandatory = $true)][string] $EnvironmentName,
    [Parameter(Mandatory = $true)][string] $ConfigFile,
    [string] $CompanyName = 'My Company'
)

$ErrorActionPreference = 'Stop'

Write-Host "Installing BcContainerHelper..."
Install-Module BcContainerHelper -Force -AllowClobber -Scope CurrentUser -MinimumVersion 6.0 | Out-Null
Import-Module BcContainerHelper -DisableNameChecking

Write-Host "Requesting a GitHub OIDC token for federated auth..."
if (-not $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN -or -not $env:ACTIONS_ID_TOKEN_REQUEST_URL) {
    throw "No GitHub OIDC token request available - the workflow needs 'permissions: id-token: write'."
}
$idToken = Invoke-RestMethod -Method Get -UseBasicParsing `
    -Headers @{ Authorization = "bearer $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN"; Accept = "application/vnd.github+json" } `
    -Uri "$($env:ACTIONS_ID_TOKEN_REQUEST_URL)&audience=api://AzureADTokenExchange"

Write-Host "Exchanging federated token for a Business Central access token..."
$authContextObj = New-BcAuthContext -clientID $ClientId -tenantID $Tenant -clientAssertion $idToken.value
if ($null -eq $authContextObj) {
    throw "Authentication failed."
}
$bearerToken = $authContextObj.AccessToken

function Invoke-BcRestMethod {
    param($Method, $Uri, $Headers, $Body, $ContentType)
    try {
        $params = @{ Method = $Method; Uri = $Uri; Headers = $Headers }
        if ($Body) { $params.Body = $Body }
        if ($ContentType) { $params.ContentType = $ContentType }
        Invoke-RestMethod @params
    } catch {
        $respBody = $null
        if ($_.Exception.Response) {
            try {
                $stream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($stream)
                $respBody = $reader.ReadToEnd()
            } catch {}
        }
        Write-Host "Request failed: $Method $Uri"
        if ($respBody) { Write-Host "Response body: $respBody" }
        throw
    }
}

$headers = @{ Authorization = "Bearer $bearerToken" }
$baseUrl = "https://api.businesscentral.dynamics.com/v2.0/$Tenant/$EnvironmentName/api/v2.0"
$apiUrl = "https://api.businesscentral.dynamics.com/v2.0/$Tenant/$EnvironmentName/api/laai/config/v1.0"

Write-Host "Looking up company '$CompanyName' in $EnvironmentName..."
$companies = Invoke-BcRestMethod -Method Get -Uri "$baseUrl/companies" -Headers $headers
if ($companies.value.Count -eq 0) {
    throw "No companies found in environment '$EnvironmentName'."
}
Write-Host "Companies found: $($companies.value.name -join ', ')"
$company = $companies.value | Where-Object { $_.name -eq $CompanyName }
if ($null -eq $company) {
    throw "Company '$CompanyName' not found in environment '$EnvironmentName'. Available: $($companies.value.name -join ', ')"
}
Write-Host "Using company '$($company.name)' ($($company.id))"

if ($env:PROBE_STANDARD_API -eq 'true') {
    Write-Host "=== PROBE: standard API v2.0 \$metadata (entity list) ==="
    try {
        $meta = Invoke-BcRestMethod -Method Get -Uri "$baseUrl/`$metadata" -Headers $headers
        $entitySetNames = [regex]::Matches($meta, 'EntitySet Name="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
        Write-Host "Entity sets ($($entitySetNames.Count) total):"
        $entitySetNames | Sort-Object | ForEach-Object { Write-Host "  - $_" }
    } catch {
        Write-Host "Metadata probe failed."
    }

    Write-Host "=== PROBE: standard 'accounts' (Chart of Accounts) entity ==="
    try {
        $accts = Invoke-BcRestMethod -Method Get -Uri "$baseUrl/companies($($company.id))/accounts?`$top=3" -Headers $headers
        Write-Host "accounts SUCCEEDED - sample: $($accts.value | ConvertTo-Json -Depth 3)"
    } catch {
        Write-Host "accounts probe failed."
    }

    Write-Host "=== PROBE complete, exiting ==="
    exit 0
}

$resourceUrl = "$apiUrl/companies($($company.id))/customerPostingGroups"

Write-Host "Reading desired state from $ConfigFile..."
$desired = (Get-Content $ConfigFile -Raw | ConvertFrom-Json).customerPostingGroups

Write-Host "Reading current state from $EnvironmentName..."
$current = (Invoke-BcRestMethod -Method Get -Uri $resourceUrl -Headers $headers).value

$fieldNames = @(
    'description', 'receivablesAccount', 'serviceChargeAcc', 'paymentDiscDebitAcc',
    'paymentDiscCreditAcc', 'interestAccount', 'additionalFeeAccount', 'addFeePerLineAccount',
    'invoiceRoundingAccount', 'debitRoundingAccount', 'creditRoundingAccount',
    'debitApplnRndgAcc', 'creditApplnRndgAcc', 'paymentToleranceDebitAcc', 'paymentToleranceCreditAcc'
)

foreach ($item in $desired) {
    $existing = $current | Where-Object { $_.code -eq $item.code }
    $body = @{}
    foreach ($f in $fieldNames) { $body[$f] = [string]$item.$f }

    if ($existing) {
        $changed = $false
        foreach ($f in $fieldNames) {
            if ([string]$existing.$f -ne [string]$item.$f) { $changed = $true }
        }
        if ($changed) {
            Write-Host "Updating $($item.code)..."
            $patchHeaders = $headers.Clone()
            $patchHeaders['If-Match'] = '*'
            Invoke-BcRestMethod -Method Patch -Uri "$resourceUrl(code='$($item.code)')" -Headers $patchHeaders -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Out-Null
        } else {
            Write-Host "$($item.code) already matches desired state."
        }
    } else {
        Write-Host "Creating $($item.code)..."
        $body['code'] = $item.code
        Invoke-BcRestMethod -Method Post -Uri $resourceUrl -Headers $headers -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Out-Null
    }
}

$desiredCodes = $desired | ForEach-Object { $_.code }
foreach ($existingItem in $current) {
    if ($existingItem.code -notin $desiredCodes) {
        Write-Host "Deleting $($existingItem.code) (not in desired state)..."
        $deleteHeaders = $headers.Clone()
        $deleteHeaders['If-Match'] = '*'
        Invoke-BcRestMethod -Method Delete -Uri "$resourceUrl(code='$($existingItem.code)')" -Headers $deleteHeaders | Out-Null
    }
}

Write-Host "Done. Customer Posting Groups in $EnvironmentName now match $ConfigFile."
