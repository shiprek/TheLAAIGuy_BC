param(
    [Parameter(Mandatory = $true)][string] $Tenant,
    [Parameter(Mandatory = $true)][string] $EnvironmentName,
    [Parameter(Mandatory = $true)][string] $AuthContext,
    [Parameter(Mandatory = $true)][string] $ConfigFile
)

$ErrorActionPreference = 'Stop'

Write-Host "Installing BcContainerHelper..."
Install-Module BcContainerHelper -Force -AllowClobber -Scope CurrentUser -MinimumVersion 6.0 | Out-Null
Import-Module BcContainerHelper -DisableNameChecking

Write-Host "Renewing auth context for tenant $Tenant..."
$authContextObj = $AuthContext | ConvertFrom-Json | ConvertTo-HashTable
$authContextObj = Renew-BcAuthContext -bcAuthContext $authContextObj
$bearerToken = $authContextObj.accessToken

$headers = @{ Authorization = "Bearer $bearerToken" }
$baseUrl = "https://api.businesscentral.dynamics.com/v2.0/$Tenant/$EnvironmentName/api/v2.0"
$apiUrl = "https://api.businesscentral.dynamics.com/v2.0/$Tenant/$EnvironmentName/api/laai/config/v1.0"

Write-Host "Looking up company in $EnvironmentName..."
$companies = Invoke-RestMethod -Method Get -Uri "$baseUrl/companies" -Headers $headers
if ($companies.value.Count -eq 0) {
    throw "No companies found in environment '$EnvironmentName'."
}
$company = $companies.value[0]
Write-Host "Using company '$($company.name)' ($($company.id))"

$resourceUrl = "$apiUrl/companies($($company.id))/customerPostingGroups"

Write-Host "Reading desired state from $ConfigFile..."
$desired = (Get-Content $ConfigFile -Raw | ConvertFrom-Json).customerPostingGroups

Write-Host "Reading current state from $EnvironmentName..."
$current = (Invoke-RestMethod -Method Get -Uri $resourceUrl -Headers $headers).value

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
            Invoke-RestMethod -Method Patch -Uri "$resourceUrl(code='$($item.code)')" -Headers $patchHeaders -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Out-Null
        } else {
            Write-Host "$($item.code) already matches desired state."
        }
    } else {
        Write-Host "Creating $($item.code)..."
        $body['code'] = $item.code
        Invoke-RestMethod -Method Post -Uri $resourceUrl -Headers $headers -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Out-Null
    }
}

$desiredCodes = $desired | ForEach-Object { $_.code }
foreach ($existingItem in $current) {
    if ($existingItem.code -notin $desiredCodes) {
        Write-Host "Deleting $($existingItem.code) (not in desired state)..."
        $deleteHeaders = $headers.Clone()
        $deleteHeaders['If-Match'] = '*'
        Invoke-RestMethod -Method Delete -Uri "$resourceUrl(code='$($existingItem.code)')" -Headers $deleteHeaders | Out-Null
    }
}

Write-Host "Done. Customer Posting Groups in $EnvironmentName now match $ConfigFile."
