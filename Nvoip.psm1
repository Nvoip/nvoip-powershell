function Get-NvoipBasicAuth {
    param(
        [string]$OAuthClientId = $env:NVOIP_OAUTH_CLIENT_ID,
        [string]$OAuthClientSecret = $env:NVOIP_OAUTH_CLIENT_SECRET
    )

    if (-not $OAuthClientId -or -not $OAuthClientSecret) {
        throw "Missing OAuth client credentials. Configure NVOIP_OAUTH_CLIENT_ID + NVOIP_OAUTH_CLIENT_SECRET."
    }

    return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$([uri]::EscapeDataString($OAuthClientId))`:$([uri]::EscapeDataString($OAuthClientSecret))"))
}

function Invoke-NvoipRequest {
    param(
        [Parameter(Mandatory = $true)][string]$Method,
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$BaseUrl = $env:NVOIP_BASE_URL,
        [hashtable]$Headers = @{},
        [object]$Body = $null
    )

    if (-not $BaseUrl) {
        $BaseUrl = "https://api.nvoip.com.br/v3"
    }

    $url = "$($BaseUrl.TrimEnd('/'))$Path"

    $params = @{
        Method      = $Method
        Uri         = $url
        Headers     = $Headers
        ErrorAction = "Stop"
    }

    if ($Body -ne $null) {
        $params.Body = $Body
    }

    if ($global:NvoipRequestHandler) {
        return & $global:NvoipRequestHandler $params
    }
    if ($env:NVOIP_TEST_TRANSPORT -eq '1') {
        $global:NvoipTestRequests += $params
        return @{ access_token = 'token' }
    }
    Invoke-RestMethod @params
}

function New-NvoipAccessToken {
    param()

    $basicAuth = Get-NvoipBasicAuth
    $body = "grant_type=client_credentials"

    Invoke-RestMethod -Method POST -Uri "https://api.nvoip.com.br/auth/oauth2/token" -Headers @{
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
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [Parameter(Mandatory = $true)][string]$Code,
        [Parameter(Mandatory = $true)][string]$Key
    )

    Invoke-NvoipRequest -Method GET -Path "/check/otp?code=$([uri]::EscapeDataString($Code))&key=$([uri]::EscapeDataString($Key))" -Headers @{ Authorization = "Bearer $AccessToken" }
}

function Get-NvoipWhatsAppTemplates {
    param([Parameter(Mandatory = $true)][string]$AccessToken)

    Invoke-NvoipRequest -Method GET -Path "/wa/listTemplates" -Headers @{
        Authorization = "Bearer $AccessToken"
    }
}

function Send-NvoipWhatsAppTemplate {
    [CmdletBinding(DefaultParameterSetName = "LegacyPhone")]
    param(
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [Parameter(Mandatory = $true)][string]$TemplateId,
        [Parameter(Mandatory = $true, ParameterSetName = "LegacyPhone")]
        [ValidatePattern('^\+?[0-9]{8,20}$')]
        [string]$Destination,
        [Parameter(Mandatory = $true, ParameterSetName = "TypedRecipient")]
        [ValidateSet("phone", "bsuid", "parent_bsuid")]
        [string]$RecipientType,
        [Parameter(Mandatory = $true, ParameterSetName = "TypedRecipient")]
        [ValidateScript({
            if ($_ -match '^@') { throw "@username is not a WhatsApp recipient; use a BSUID or parent BSUID" }
            -not [string]::IsNullOrWhiteSpace($_)
        })]
        [string]$RecipientValue,
        [Parameter(Mandatory = $true)][string]$Instance,
        [string]$Language = "pt_BR",
        [array]$BodyVariables = @(),
        [array]$HeaderVariables = @(),
        [bool]$ToFlow = $false
    )

    $payload = @{
        idTemplate = $TemplateId
        instance = $Instance
        language = $Language
    }
    if ($PSCmdlet.ParameterSetName -eq "TypedRecipient") {
        if ($RecipientType -eq "phone" -and $RecipientValue -notmatch '^\+?[0-9]{8,20}$') {
            throw "A phone recipient must contain only an optional leading + and 8 to 20 digits."
        }
        if ($ToFlow -and $RecipientType -ne "phone") {
            throw "WhatsApp Flow and attendance require a phone recipient."
        }
        $payload.recipient = @{ type = $RecipientType; value = $RecipientValue }
    } else {
        $payload.destination = $Destination
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
