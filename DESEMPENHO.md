# Medições e limites

## v2: históricos de diagnóstico

FNTRACE: 4.194.304 → 16.384 entradas. SIO trace e IRQ: 1.048.576 → 16.384 cada. SIO transaction: 65.536 → 1.024.

Em duas inicializações de cada versão, memória privada comprometida média caiu de 728,3 para 484,1 MiB (aproximadamente 33,5%). Memória residente ficou em 186,8 versus 186,0 MiB; CPU praticamente igual. O ganho foi de comprometimento de memória, não de FPS. Menos histórico fica disponível para investigar problemas.

## v3: espera de quadros

O caminho anterior espera ativamente por aproximadamente 1–2 ms antes do próximo quadro. A alteração usa o temporizador de alta resolução existente durante mais desse intervalo e deixa uma reserva nominal de 250 microssegundos. Mantém prazos, ciclos e recuperação de atrasos.

Ryzen 5 5600GT / RTX 5050, janela oculta, nativo/1x, Release sem servidor de diagnóstico, PATH restrito ao Windows. Estado de uma luta DanzaiVer contra Al preparado em build instrumental e recarregado nas execuções de distribuição. 5 s de aquecimento e aproximadamente 30,4 s de coleta por execução. Ordem: v2, teste de renderização separada, v3, v3, v2.

| Medida | v2 | v3 |
|---|---:|---:|
| Tempo de CPU na execução 1 | 17,594 s | 16,250 s |
| Tempo de CPU na execução 2 | 18,281 s | 15,922 s |
| CPU por segundo decorrido (média) | 0,590 s | 0,529 s |
| Cadência média PS1 | 59,93 Hz | 59,91 Hz |
| Underruns / overflows de áudio registrados | 0 / 0 | 0 / 0 |

Redução aproximada de 10% de tempo de CPU nessa amostra. Não significa 10% mais FPS, menos 10 pontos percentuais de CPU total ou melhoria garantida em outro PC. Os contadores medem cadência PS1, não apresentação efetiva no monitor. Não foi feita avaliação auditiva nesta comparação. Dados numéricos: [benchmark-v3.json](benchmark-v3.json).

Renderização separada consumiu 21,016 s de CPU e 565,7 MiB privados no experimento, contra 17,594 s e 499,5 MiB da primeira referência; ficou desligada. São amostras curtas, não uma análise estatística abrangente.

Testes unitários passaram nos caminhos antigo e novo, incluindo prazos expirados, frequência zero e limite da espera. Inicialização adicional sem savestate também foi executada. O usuário posteriormente aprovou a Legacy no notebook ligado à tomada; não foram medidos todos os modos nem consumo elétrico. O estado de teste, screenshots comerciais e logs com caminhos pessoais foram excluídos deste repositório.
