# Publicação no GitHub

Nome sugerido: **Evil_Zone-Legacy**. Descrição: `Patches e documentação da edição Legacy de Evil Zone para Windows x64. Sem ROM, BIOS ou executável comercial.`

Esta preparação é local. Nenhum repositório remoto foi criado e nenhum arquivo foi enviado. Não existe URL remota configurada neste kit.

## Criar e enviar

1. Revise esta pasta. Ela deve conter apenas o kit textual; não adicione as pastas de jogos privados.
2. Crie um repositório vazio na sua conta GitHub com o nome sugerido. Não gere outro README ou licença pelo formulário.
3. Na pasta do kit, execute os comandos abaixo, substituindo SEU_USUARIO pelo login real. O commit usa a identidade Git configurada por você.

```powershell
git add .
python scripts/audit_repo.py
git diff --cached --stat
git commit -m "Prepare Legacy v3 optimization kit"
git remote add origin https://github.com/SEU_USUARIO/Evil_Zone-Legacy.git
git push -u origin main
```

O repositório local foi inicializado com branch main, mas sem commit em nome de outra pessoa. Se estiver usando uma cópia extraída do ZIP sem .git, execute `git init -b main` antes de `git add .`.

## Release de código

Título sugerido: `v0.3.0 — Legacy optimization kit`. Use o CHANGELOG e destaque que o download contém patches, não o jogo pronto para executar. A criação de uma Release é opcional. Não anexe os ZIPs EvilZone-Legacy.zip ou EvilZone-1080p.zip da instalação privada.

A auditoria do Actions verifica os arquivos versionados, mas não inspeciona anexos de Releases nem prova ausência de todo conteúdo protegido. A revisão humana continua necessária. Não há workflow de upload automático, compilação do jogo ou publicação de executáveis.
