# nvoip-powershell

Módulo e exemplos oficiais da [Nvoip](https://www.nvoip.com.br/) para integrar a API v2 com OAuth, chamadas, OTP, WhatsApp, SMS e saldo em PowerShell.

## Requisitos

- PowerShell 7+

## Configuração

```powershell
$env:NVOIP_NUMBERSIP = "seu_numbersip"
$env:NVOIP_USER_TOKEN = "seu_user_token"
$env:NVOIP_OAUTH_CLIENT_ID = "seu_client_id"
$env:NVOIP_OAUTH_CLIENT_SECRET = "seu_client_secret"
$env:NVOIP_CALLER = "1049"
$env:NVOIP_TARGET_NUMBER = "11999999999"
```

## Fluxos cobertos

- gerar `access_token`
- consultar saldo
- enviar SMS
- realizar chamada
- enviar OTP
- validar OTP
- listar templates de WhatsApp
- enviar template de WhatsApp

## Exemplos

- `pwsh examples/create-access-token.ps1`
- `pwsh examples/get-balance.ps1`
- `pwsh examples/send-sms.ps1`
- `pwsh examples/create-call.ps1`
- `pwsh examples/send-otp.ps1`
- `pwsh examples/check-otp.ps1`
- `pwsh examples/list-whatsapp-templates.ps1`
- `pwsh examples/send-whatsapp-template.ps1`

## SDK web

Para o fluxo de popup com telefone e código, use em conjunto o repositório `nvoip-web-sdk`. Este repo cobre o consumo server-side da API.

## Documentação oficial

- https://nvoip.docs.apiary.io/
- https://www.nvoip.com.br/api
