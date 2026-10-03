$env:NVOIP_TEST_TRANSPORT = '1'; $global:NvoipTestRequests = @()
Import-Module (Join-Path $PSScriptRoot '../Nvoip.psm1') -Force
$env:NVOIP_OAUTH_CLIENT_ID = 'id +'; $env:NVOIP_OAUTH_CLIENT_SECRET = 'secret:/'
New-NvoipAccessToken | Out-Null
Get-NvoipBalance -AccessToken token | Out-Null
Test-NvoipOtp -AccessToken token -Code 'a b' -Key 'key/1' | Out-Null
if ($global:NvoipTestRequests[0].Body -ne 'grant_type=client_credentials') { throw 'OAuth form was not serialized' }
if ($global:NvoipTestRequests[0].Headers.Authorization -notmatch '^Basic ') { throw 'OAuth Basic header missing' }
if ($global:NvoipTestRequests[1].Headers.Authorization -ne 'Bearer token' -or $global:NvoipTestRequests[2].Headers.Authorization -ne 'Bearer token') { throw 'Bearer header missing' }
