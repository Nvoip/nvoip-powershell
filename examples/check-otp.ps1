Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$accessToken = if ($env:NVOIP_ACCESS_TOKEN) { $env:NVOIP_ACCESS_TOKEN } else { (New-NvoipAccessToken).access_token }
Test-NvoipOtp -AccessToken $accessToken -Code $env:NVOIP_OTP_CODE -Key $env:NVOIP_OTP_KEY | ConvertTo-Json -Depth 10
