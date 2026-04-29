Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
Send-NvoipSms -AccessToken $oauth.access_token -NumberPhone ($env:NVOIP_TARGET_NUMBER ?? "11999999999") -Message ($env:NVOIP_SMS_MESSAGE ?? "Mensagem de teste Nvoip") | ConvertTo-Json -Depth 10
