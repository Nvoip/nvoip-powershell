@{
    RootModule        = 'Nvoip.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '521D4172-84D9-440C-BCAD-9A572C3DD86A'
    Author            = 'Nvoip'
    CompanyName       = 'Nvoip'
    Copyright         = '(c) Nvoip. Licensed under GPL-3.0-only.'
    Description       = 'SDK PowerShell oficial para integrar OAuth, chamadas, OTP, WhatsApp, SMS e saldo com a API v2 da Nvoip.'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Get-NvoipBasicAuth',
        'Invoke-NvoipRequest',
        'New-NvoipAccessToken',
        'Get-NvoipBalance',
        'Send-NvoipSms',
        'New-NvoipCall',
        'Send-NvoipOtp',
        'Test-NvoipOtp',
        'Get-NvoipWhatsAppTemplates',
        'Send-NvoipWhatsAppTemplate'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('nvoip', 'voip', 'telefonia', 'sms', 'whatsapp', 'otp', 'api')
            LicenseUri = 'https://www.gnu.org/licenses/gpl-3.0-standalone.html'
            ProjectUri = 'https://www.nvoip.com.br/'
            ReleaseNotes = 'Initial public SDK package for the Nvoip API v2.'
        }
    }
}
