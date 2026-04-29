Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
$oauth = New-NvoipAccessToken
Get-NvoipBalance -AccessToken $oauth.access_token | ConvertTo-Json -Depth 10
