# Evil_Zone Legacy

Kit de otimização da edição Legacy de um projeto local de recompilação de **Evil Zone (PS1)** para Windows x64. Projeto independente, sem afiliação aos titulares do jogo.

**Este repositório contém patches e documentação. Não é um download do jogo completo.** Não inclui disco, código comercial recompilado, executável do jogo, cache de overlays, BIOS, imagens, músicas ou saves. A versão portátil privada não deve ser anexada às Releases deste repositório.

## O que a Legacy faz

- Resolução interna nativa/1x, sem antialiasing, correções geométricas ou geração de quadros.
- Históricos de diagnóstico menores: aproximadamente 244 MiB a menos de memória privada comprometida no teste v1/v2.
- Espera entre quadros mais eficiente: aproximadamente 10% menos tempo de CPU na cena medida entre v2/v3.
- Mantém a temporização do PS1 e o buffer de áudio existente; não habilita turbo ou salto de loops.

Esses números não representam aumento equivalente de FPS. Consulte [medições e limitações](docs/DESEMPENHO.md).

## Conteúdo

| Pasta | Conteúdo |
|---|---|
| `patches/` | Patch combinado v3 e hashes dos arquivos da base local |
| `config/` | Perfil gráfico Legacy, sem identificação pessoal de controle |
| `scripts/` | Aplicação verificada do patch, iniciadores e auditoria do repositório |
| `docs/` | Compilação, requisitos, medições, licenças e publicação |

## Como usar

1. Leia [COMPILACAO.md](docs/COMPILACAO.md). É necessário ter separadamente um projeto-base completo e compatível, obtido de forma autorizada.
2. Aplique o patch **em uma cópia** desse projeto com `scripts/Apply-LegacyPatch.ps1`.
3. Compile com as duas opções Legacy habilitadas e ferramentas de diagnóstico desabilitadas.
4. Monte o pacote privado com os recursos autorizados do seu projeto. Copie os iniciadores de `scripts/` para a pasta do executável e `config/settings-legacy.toml` como `settings.toml` somente em uma instalação nova; preserve configurações e saves existentes.
5. Abra `Iniciar.cmd`. Para investigar lentidão, use `Diagnosticar.cmd`; os registros ficam localmente em `diagnosticos/`.

**Clonar este repositório sozinho não permite compilar nem iniciar o jogo.** Não há um commit público verificado que reconstrua integralmente a base local. Não apresentamos a compilação como reproduzível a partir de um clone limpo.

## Dependências e compatibilidade

Alvo: Windows 10/11 x64 com UCRT e driver OpenGL 3.3. Legacy não significa suporte a Windows antigo. Os mínimos reais de CPU/GPU ainda não foram determinados; veja [REQUISITOS.md](docs/REQUISITOS.md).

O pacote privado testado depende da imagem BIN/CUE de Evil Zone NTSC-U, serial SLUS-00855, do executável de boot extraído e da OpenBIOS. A recompilação não elimina essas dependências. Este repositório não fornece esses arquivos nem links de download de conteúdo comercial. ISO/CHD alternativos não foram validados.

## Estado da validação

- Testes locais: Ryzen 5 5600GT / RTX 5050, Windows x64.
- Usuário relatou Legacy fluida em notebook com i5-13420H conectado à tomada; RAM e GPU efetivamente utilizadas não foram registradas.
- Não há validação de todos os personagens, fases, controles, sistemas ou notebooks.
- A versão Normal 1080p privada foi preservada; não está incluída neste kit Legacy.

## Licença e contribuições

Os patches do framework mantêm a licença [PolyForm Noncommercial 1.0.0](LICENSE) e o aviso de copyright original. Veja [LICENCAS.md](docs/LICENCAS.md). Essa licença não concede direitos sobre o jogo comercial. Não se trata de um projeto MIT nem de software com permissão irrestrita de uso comercial.

Relatos de problemas devem conter modelo de CPU/GPU, memória, driver, revisão usada e trecho do problema. Remova informações pessoais dos logs e não envie ROMs, saves ou arquivos do jogo. Consulte [CONTRIBUTING.md](CONTRIBUTING.md).
