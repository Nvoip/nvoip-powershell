Import-Module "$PSScriptRoot/../Nvoip.psm1" -Force
Test-NvoipOtp -Code $env:NVOIP_OTP_CODE -Key $env:NVOIP_OTP_KEY | ConvertTo-Json -Depth 10
