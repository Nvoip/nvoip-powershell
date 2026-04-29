function Get-NvoipBasicAuth {
    param(
        [string]$OAuthClientId = $env:NVOIP_OAUTH_CLIENT_ID,
        [string]$OAuthClientSecret = $env:NVOIP_OAUTH_CLIENT_SECRET
    )

    if (-not $OAuthClientId -or -not $OAuthClientSecret) {
        throw "Missing OAuth client credentials. Configure NVOIP_OAUTH_CLIENT_ID + NVOIP_OAUTH_CLIENT_SECRET."
    }

    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$OAuthClientId`:$OAuthClientSecret"))
}

function Invoke-NvoipRequest {
    param(
        [Parameter(Mandatory = $true)][string]$Method,
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$BaseUrl = $env:NVOIP_BASE_URL,
        [hashtable]$Headers = @{},
        [object]$Body = $null,
        [string]$Napikey
    )

    if (-not $BaseUrl) {
        $BaseUrl = "https://api.nvoip.com.br/v2"
    }

    $url = "$($BaseUrl.TrimEnd('/'))$Path"
    if ($Napikey) {
        $separator = $url.Contains("?") ? "&" : "?"
        $url = "$url${separator}napikey=$([uri]::EscapeDataString($Napikey))"
    }

    $params = @{
        Method      = $Method
        Uri         = $url
        Headers     = $Headers
        ErrorAction = "Stop"
    }

    if ($Body -ne $null) {
        $params.Body = $Body
    }

    Invoke-RestMethod @params
}

function New-NvoipAccessToken {
    param(
        [string]$Numbersip = $env:NVOIP_NUMBERSIP,
        [string]$UserToken = $env:NVOIP_USER_TOKEN
    )

    $basicAuth = Get-NvoipBasicAuth
    $body = "username=$([uri]::EscapeDataString($Numbersip))&password=$([uri]::EscapeDataString($UserToken))&grant_type=password"

    Invoke-NvoipRequest -Method POST -Path "/oauth/token" -Headers @{
        Authorization = "Basic $basicAuth"
        "Content-Type" = "application/x-www-form-urlencoded"
    } -Body $body
}

function Get-NvoipBalance {
    param([Parameter(Mandatory = $true)][string]$AccessToken)

    Invoke-NvoipRequest -Method GET -Path "/balance" -Headers @{
        Authorization = "Bearer $AccessToken"
    }
}

function Send-NvoipSms {
    param(
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [Parameter(Mandatory = $true)][string]$NumberPhone,
        [Parameter(Mandatory = $true)][string]$Message
    )

    Invoke-NvoipRequest -Method POST -Path "/sms" -Headers @{
        Authorization = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    } -Body (@{
        numberPhone = $NumberPhone
        message = $Message
        flashSms = $false
    } | ConvertTo-Json -Depth 4)
}

function New-NvoipCall {
    param(
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [Parameter(Mandatory = $true)][string]$Caller,
        [Parameter(Mandatory = $true)][string]$Called
    )

    Invoke-NvoipRequest -Method POST -Path "/calls/" -Headers @{
        Authorization = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    } -Body (@{
        caller = $Caller
        called = $Called
    } | ConvertTo-Json -Depth 4)
}

function Send-NvoipOtp {
    param(
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [string]$Sms,
        [string]$Voice,
        [string]$Email
    )

    $payload = @{}
    if ($Sms) { $payload.sms = $Sms }
    if ($Voice) { $payload.voice = $Voice }
    if ($Email) { $payload.email = $Email }

    Invoke-NvoipRequest -Method POST -Path "/otp" -Headers @{
        Authorization = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    } -Body ($payload | ConvertTo-Json -Depth 4)
}

function Test-NvoipOtp {
    param(
        [Parameter(Mandatory = $true)][string]$Code,
        [Parameter(Mandatory = $true)][string]$Key
    )

    Invoke-NvoipRequest -Method GET -Path "/check/otp?code=$([uri]::EscapeDataString($Code))&key=$([uri]::EscapeDataString($Key))"
}

function Get-NvoipWhatsAppTemplates {
    param([Parameter(Mandatory = $true)][string]$AccessToken)

    Invoke-NvoipRequest -Method GET -Path "/wa/listTemplates" -Headers @{
        Authorization = "Bearer $AccessToken"
    }
}

function Send-NvoipWhatsAppTemplate {
    param(
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [Parameter(Mandatory = $true)][string]$TemplateId,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][string]$Instance,
        [string]$Language = "pt_BR",
        [array]$BodyVariables = @(),
        [array]$HeaderVariables = @(),
        [bool]$ToFlow = $false
    )

    $payload = @{
        idTemplate = $TemplateId
        destination = $Destination
        instance = $Instance
        language = $Language
    }

    if ($BodyVariables.Count -gt 0) { $payload.bodyVariables = $BodyVariables }
    if ($HeaderVariables.Count -gt 0) { $payload.headerVariables = $HeaderVariables }
    if ($ToFlow) { $payload.functions = @{ to_flow = $true } }

    Invoke-NvoipRequest -Method POST -Path "/wa/sendTemplates" -Headers @{
        Authorization = "Bearer $AccessToken"
        "Content-Type" = "application/json"
    } -Body ($payload | ConvertTo-Json -Depth 6)
}

Export-ModuleMember -Function *-Nvoip*
