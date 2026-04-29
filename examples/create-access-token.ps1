Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
New-NvoipAccessToken | ConvertTo-Json -Depth 10
