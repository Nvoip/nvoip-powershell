Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
$bodyVariables = if ($env:NVOIP_WA_BODY_VARIABLES) { $env:NVOIP_WA_BODY_VARIABLES | ConvertFrom-Json } else { @() }
$headerVariables = if ($env:NVOIP_WA_HEADER_VARIABLES) { $env:NVOIP_WA_HEADER_VARIABLES | ConvertFrom-Json } else { @() }
$toFlow = ($env:NVOIP_WA_TO_FLOW ?? "false") -eq "true"
$recipientArguments = if ($env:NVOIP_WA_RECIPIENT_TYPE) {
    @{
        RecipientType = $env:NVOIP_WA_RECIPIENT_TYPE
        RecipientValue = $env:NVOIP_WA_RECIPIENT_VALUE
    }
} else {
    @{ Destination = ($env:NVOIP_WA_DESTINATION ?? $env:NVOIP_TARGET_NUMBER) }
}

Send-NvoipWhatsAppTemplate `
    -AccessToken $oauth.access_token `
    -TemplateId $env:NVOIP_WA_TEMPLATE_ID `
    -Instance $env:NVOIP_WA_INSTANCE `
    -Language ($env:NVOIP_WA_LANGUAGE ?? "pt_BR") `
    -BodyVariables $bodyVariables `
    -HeaderVariables $headerVariables `
    -ToFlow:$toFlow `
    @recipientArguments | ConvertTo-Json -Depth 10
