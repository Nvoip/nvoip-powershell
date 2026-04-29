Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
$bodyVariables = if ($env:NVOIP_WA_BODY_VARIABLES) { $env:NVOIP_WA_BODY_VARIABLES | ConvertFrom-Json } else { @() }
$headerVariables = if ($env:NVOIP_WA_HEADER_VARIABLES) { $env:NVOIP_WA_HEADER_VARIABLES | ConvertFrom-Json } else { @() }
$toFlow = ($env:NVOIP_WA_TO_FLOW ?? "false") -eq "true"

Send-NvoipWhatsAppTemplate `
    -AccessToken $oauth.access_token `
    -TemplateId $env:NVOIP_WA_TEMPLATE_ID `
    -Destination ($env:NVOIP_WA_DESTINATION ?? $env:NVOIP_TARGET_NUMBER) `
    -Instance $env:NVOIP_WA_INSTANCE `
    -Language ($env:NVOIP_WA_LANGUAGE ?? "pt_BR") `
    -BodyVariables $bodyVariables `
    -HeaderVariables $headerVariables `
    -ToFlow:$toFlow | ConvertTo-Json -Depth 10
