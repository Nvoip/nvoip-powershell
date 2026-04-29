# nvoip-powershell

[![Nvoip](https://img.shields.io/badge/Nvoip-site-00A3E0?style=flat-square)](https://www.nvoip.com.br/) [![API v2](https://img.shields.io/badge/API-v2-1F6FEB?style=flat-square)](https://www.nvoip.com.br/api/) [![Docs](https://img.shields.io/badge/docs-Apiary-6A737D?style=flat-square)](https://nvoip.docs.apiary.io/) [![Postman](https://img.shields.io/badge/Postman-workspace-FF6C37?style=flat-square)](https://nvoip-api.postman.co/workspace/e671d01f-168a-4c38-8d0e-c217229dd61a/team-quickstart) [![Stack](https://img.shields.io/badge/stack-PowerShell-5391FE?style=flat-square)](https://github.com/Nvoip/nvoip-api-examples) [![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square)](LICENSE)

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

## Links oficiais

- [Site da Nvoip](https://www.nvoip.com.br/)
- [Documentação da API](https://nvoip.docs.apiary.io/)
- [Página da API](https://www.nvoip.com.br/api/)
- [Workspace Postman](https://nvoip-api.postman.co/workspace/e671d01f-168a-4c38-8d0e-c217229dd61a/team-quickstart)
- [Hub de exemplos](https://github.com/Nvoip/nvoip-api-examples)
