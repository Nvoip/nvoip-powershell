$script:requests = @()
function Invoke-RestMethod { param($Method,$Uri,$Headers,$Body,$ErrorAction) $script:requests += @{ Uri=$Uri; Headers=$Headers; Body=$Body }; @{ access_token='token' } }
$modulePath = Join-Path (Split-Path $PSScriptRoot -Parent) 'Nvoip.psm1'
. $modulePath
$env:NVOIP_OAUTH_CLIENT_ID = 'id +'; $env:NVOIP_OAUTH_CLIENT_SECRET = 'secret:/'
New-NvoipAccessToken | Out-Null
Get-NvoipBalance -AccessToken token | Out-Null
Test-NvoipOtp -AccessToken token -Code 'a b' -Key 'key/1' | Out-Null
if ($script:requests[0].Body -ne 'grant_type=client_credentials') { throw 'OAuth form was not serialized' }
if ($script:requests[0].Headers.Authorization -notmatch '^Basic ') { throw 'OAuth Basic header missing' }
if ($script:requests[1].Headers.Authorization -ne 'Bearer token' -or $script:requests[2].Headers.Authorization -ne 'Bearer token') { throw 'Bearer header missing' }
