$global:requests = @()
Import-Module (Join-Path $PSScriptRoot '../Nvoip.psm1') -Force
& (Get-Module Nvoip) { $script:NvoipRequestHandler = { param($params) $global:requests += $params; @{ access_token='token' } } }
$env:NVOIP_OAUTH_CLIENT_ID = 'id +'; $env:NVOIP_OAUTH_CLIENT_SECRET = 'secret:/'
New-NvoipAccessToken | Out-Null
Get-NvoipBalance -AccessToken token | Out-Null
Test-NvoipOtp -AccessToken token -Code 'a b' -Key 'key/1' | Out-Null
if ($global:requests[0].Body -ne 'grant_type=client_credentials') { throw 'OAuth form was not serialized' }
if ($global:requests[0].Headers.Authorization -notmatch '^Basic ') { throw 'OAuth Basic header missing' }
if ($global:requests[1].Headers.Authorization -ne 'Bearer token' -or $global:requests[2].Headers.Authorization -ne 'Bearer token') { throw 'Bearer header missing' }
