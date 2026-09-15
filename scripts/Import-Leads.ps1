param(
    [Parameter(Mandatory = $true)][string] $Tenant,
    [Parameter(Mandatory = $true)][string] $ClientId,
    [Parameter(Mandatory = $true)][string] $EnvironmentName,
    [Parameter(Mandatory = $true)][string] $LeadsFile,
    [string] $CompanyName = 'My Company',
    [string] $ResultsFile = './import-results.json'
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
$apiUrl = "https://api.businesscentral.dynamics.com/v2.0/$Tenant/$EnvironmentName/api/laai/leads/v1.0"

Write-Host "Looking up company '$CompanyName' in $EnvironmentName..."
$companies = Invoke-BcRestMethod -Method Get -Uri "$baseUrl/companies" -Headers $headers
$company = $companies.value | Where-Object { $_.name -eq $CompanyName }
if ($null -eq $company) {
    throw "Company '$CompanyName' not found in environment '$EnvironmentName'. Available: $($companies.value.name -join ', ')"
}
Write-Host "Using company '$($company.name)' ($($company.id))"

$resourceUrl = "$apiUrl/companies($($company.id))/leads"

Write-Host "Reading leads to import from $LeadsFile..."
$batch = (Get-Content $LeadsFile -Raw | ConvertFrom-Json)
$desired = $batch.leads
Write-Host "Batch '$($batch.batch)': $($desired.Count) leads."

Write-Host "Reading existing leads from $EnvironmentName (to avoid duplicates by Company Name)..."
$existing = (Invoke-BcRestMethod -Method Get -Uri "$resourceUrl`?`$select=companyName,no" -Headers $headers).value
$existingByCompanyName = @{}
foreach ($e in $existing) { $existingByCompanyName[$e.companyName.Trim().ToLowerInvariant()] = $e.no }

$created = 0
$skipped = 0
$results = @()
foreach ($lead in $desired) {
    $key = $lead.companyName.Trim().ToLowerInvariant()
    if ($existingByCompanyName.ContainsKey($key)) {
        $existingNo = $existingByCompanyName[$key]
        Write-Host "Skipping '$($lead.companyName)' - a lead with this Company Name already exists ($existingNo)."
        $results += [ordered]@{ companyName = $lead.companyName; no = $existingNo; action = 'skipped' }
        $skipped++
        continue
    }

    $body = @{
        name        = $lead.name
        companyName = $lead.companyName
        email       = $lead.email
        phoneNo     = $lead.phoneNo
        status      = $lead.status
        source      = $lead.source
        notes       = $lead.notes
    }
    Write-Host "Creating lead for '$($lead.companyName)'..."
    $createdLead = Invoke-BcRestMethod -Method Post -Uri $resourceUrl -Headers $headers -Body ($body | ConvertTo-Json) -ContentType 'application/json'
    Write-Host "  -> $($createdLead.no)"
    $results += [ordered]@{ companyName = $lead.companyName; no = $createdLead.no; action = 'created' }
    $existingByCompanyName[$key] = $createdLead.no
    $created++
}

Write-Host "Writing results for $($results.Count) lead(s) to $ResultsFile..."
[ordered]@{ batch = $batch.batch; environmentName = $EnvironmentName; results = $results } | ConvertTo-Json -Depth 5 | Set-Content -Path $ResultsFile -Encoding utf8

Write-Host "Done. Created $created lead(s), skipped $skipped already-existing lead(s) from $LeadsFile."
