Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
New-NvoipCall -AccessToken $oauth.access_token -Caller $env:NVOIP_CALLER -Called ($env:NVOIP_TARGET_NUMBER ?? "11999999999") | ConvertTo-Json -Depth 10
