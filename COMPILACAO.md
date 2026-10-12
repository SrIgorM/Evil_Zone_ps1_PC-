# Aplicação e compilação local

## Base necessária

Este kit foi extraído de um projeto local completo EvilZoneRecomp. Não havia commit HEAD nem remoto verificável na raiz dessa base. A referência do submódulo presente no projeto era `https://github.com/mstan/psxrecomp.git`, e a UI referenciava `https://github.com/RetroPortingToolKit/recomp-ui.git`. Esses links são referências de origem, não uma afirmação de que as versões atuais reproduzem a base usada.

O kit não fornece o código C gerado do jogo, bibliotecas, toolchain, ativos nem código completo do framework. É necessário obtê-los separadamente com autorização. Os cinco arquivos de entrada são identificados por SHA-256 em `patches/source-files.json`; isso identifica esses arquivos, não a totalidade das dependências.

## Aplicar o patch

Instale Git e use uma cópia descartável do projeto compatível. Na pasta deste kit:

```powershell
.\scripts\Apply-LegacyPatch.ps1 -SourceRoot 'D:\Projetos\EvilZone-copia'
```

O script confere todos os hashes antes de alterar qualquer arquivo e executa `git apply --check`. Se a base divergir, para sem aplicar; não tente forçar. Um projeto já atualizado também será recusado. O patch combinado deve ser aplicado sobre a base original, não sobre a v2.

## Compilar

Use CMake, Ninja, Clang/Clang++ para Windows x64 e as dependências exigidas pelo projeto-base. O build testado utilizou o toolchain local retcomm cmake-clang-v1 e dependências libchdr/libwebp já disponíveis. Não há instalação automatizada dessas dependências neste kit.

Exemplo, em um ambiente de desenvolvimento corretamente configurado:

```powershell
cmake -S 'D:\Projetos\EvilZone-copia' -B 'D:\Projetos\EvilZone-build' -G Ninja `
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ `
  -DPSX_LEGACY_SMALL_DIAGNOSTICS=ON -DPSX_LEGACY_EFFICIENT_PACING=ON `
  -DPSX_DEBUG_TOOLS=OFF -DPSX_NETPLAY=OFF -DPSX_PGXP_VARIANT=OFF -DPSX_STATIC_RUNTIME=ON
cmake --build 'D:\Projetos\EvilZone-build' --target psx-runtime --parallel 2
```

Pode ser necessário configurar CMAKE_PREFIX_PATH e os diretórios de dependências de acordo com o projeto-base. O exemplo não foi testado em uma máquina limpa.

Atualize o descriptor de execução com o script do próprio projeto:

```powershell
python 'D:\Projetos\EvilZone-copia\psxrecomp\tools\release_stage.py' stage-execution `
  --binary 'D:\Projetos\EvilZone-build\EvilZone_Recompiled.exe' `
  --manifest 'D:\Projetos\EvilZone-build\EvilZone_Recompiled.execution.json'
```

Não publique automaticamente o EXE produzido: ele contém código gerado a partir do jogo. O cache de overlays também foi excluído desta preparação pública.

## Testar

O patch inclui testes no arquivo `psxrecomp/runtime/tests/test_frame_pacing.c`. Compile esse teste com o include `psxrecomp/runtime/include`, uma vez sem definições e outra com `-DPSX_LEGACY_EFFICIENT_PACING=1`. Ambos devem retornar zero. Teste inicialização, partida, áudio, controles e saves em uma cópia privada isolada antes de substituir um pacote existente.

Scripts de iniciar/diagnosticar devem ficar ao lado do executável privado, não dentro de uma subpasta scripts. O perfil de configuração fornecido não contém vínculos de controle do computador original; selecione seu dispositivo no launcher.
