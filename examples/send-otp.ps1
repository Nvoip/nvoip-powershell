Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
Send-NvoipOtp -AccessToken $oauth.access_token -Sms ($env:NVOIP_OTP_SMS ?? $env:NVOIP_TARGET_NUMBER) -Voice $env:NVOIP_OTP_VOICE -Email $env:NVOIP_OTP_EMAIL | ConvertTo-Json -Depth 10
