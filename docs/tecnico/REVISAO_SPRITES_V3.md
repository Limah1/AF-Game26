# Revisão de assets/Sprites-v3 — 02/10/2026

Escopo: somente `res://assets/Sprites-v3/`. Revisão histórica de 154 PNGs-fonte, seguida de limpeza autorizada em 02/10/2026: os 130 arquivos da segunda lista foram removidos. Os 24 arquivos da primeira lista continuam existentes e usados. Metadados `.import` são separados; scripts não foram alterados.

## Totais da revisão antes da limpeza

| Categoria nesta revisão | Arquivos | Bytes | MiB | Categoria no CSV |
|---|---:|---:|---:|---|
| Em uso | 24 | 5086327 | 4.851 | Jogo atual |
| Sem uso identificado após resolver o carregador | 130 | 129158228 | 123.175 | Uso incerto |

## Evidências e limites

`CharacterController.gd:197` chama `Load_Plataform()`. A única referência de código/recursos à pasta é o padrão em `CharacterController.gd:296`: `res://assets/Sprites-v3/%s-banho/%s-banho-`. `bath_prefix` só pode ser `boy` ou `girl`; são carregados `m0` a `m5`, limpos e com sufixo `-s`, totalizando exatamente 24 caminhos. Gênero diferente de `boy` seleciona `girl`; cabelo, roupa, tom de pele e clima não modificam esses caminhos de banho.

`src/UI/Player.gd:440` (`set_bath_clothes`) e `:457` (`set_bath_dirty_clothes`) consomem essas texturas, nos nós `$player_sprites/idle` e `w1` a `w5`. `tests/test_android_regressions.gd:20` também chama `Load_Plataform()`. O minigame de banho propriamente dito usa os corpos de `assets/SpritesV4/MiniGameBanho/`, que não substituem as dependências do jogador da casa.

O prefixo genérico do scanner mantém conservadoramente os outros 130 PNGs como `Uso incerto`. A revisão do único produtor do caminho resolve os dois valores e seis frames e exclui os 130 desse carregador. Não há consumidores literais desses 130 no scanner, referências em testes/catálogos/projeto aninhado nem descoberta de diretórios em runtime encontrada que acrescente arquivos dessa pasta. Por isso são listados como **sem uso identificado**, e a revisão inicial preservou o CSV conservador. Após a limpeza autorizada, o inventário foi regenerado sem os arquivos removidos. Essa conclusão se refere ao código/recursos atuais revisados, não é prova universal de ausência de uso nem autorização de exclusão.

Não foram interpretados conteúdos de arquivos compactados, `.res`/`.scn` ou formatos de autoria externos; nomes antigos e tamanho não foram usados como evidência. `Sprites-v3/boy-a.7z` já estava excluído antes desta revisão e não integra a lista. Presets `all_resources` podem exportar PNGs não consumidos: bytes-fonte não medem economia no APK. Nenhum teste que grava saves reais foi executado.

Validação: `inventory_assets.py --self-check` e `--check` passaram na revisão inicial (2.869 assets no projeto). Na revisão inicial, os 154 caminhos do relatório existiam; os 24 caminhos do padrão finito coincidem com os 24 classificados como jogo atual. Há 156 metadados adjacentes na pasta, dois sem PNG correspondente; foram preservados.

## Em uso — lista completa

| Caminho concreto | Bytes | Categoria | Consumidor / evidência |
|---|---:|---|---|
| `res://assets/Sprites-v3/boy-banho/boy-banho-m0-s.png` | 214365 | Em uso | CharacterController.Load_Plataform → plataform.idle_bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m0.png` | 187837 | Em uso | CharacterController.Load_Plataform → plataform.idle_bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m1-s.png` | 229009 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m1.png` | 201596 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m2-s.png` | 221283 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m2.png` | 193526 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m3-s.png` | 212970 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m3.png` | 186108 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m4-s.png` | 218139 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m4.png` | 191122 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m5-s.png` | 227999 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/boy-banho/boy-banho-m5.png` | 200449 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m0-s.png` | 225213 | Em uso | CharacterController.Load_Plataform → plataform.idle_bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m0.png` | 198376 | Em uso | CharacterController.Load_Plataform → plataform.idle_bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m1-s.png` | 239066 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m1.png` | 211161 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m2-s.png` | 230280 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m2.png` | 202492 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m3-s.png` | 219781 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m3.png` | 193072 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m4-s.png` | 229843 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m4.png` | 202757 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m5-s.png` | 238874 | Em uso | CharacterController.Load_Plataform → plataform.bath_dirty; src/UI/Player.gd |
| `res://assets/Sprites-v3/girl-banho/girl-banho-m5.png` | 211009 | Em uso | CharacterController.Load_Plataform → plataform.bath; src/UI/Player.gd |

## Removidos em 02/10/2026 — lista histórica completa

Cada linha abaixo era `Uso incerto` no inventário antes da limpeza: não possuía consumidor literal e não correspondia aos caminhos finitos de banho usados acima. Estes 130 arquivos e seus 130 metadados adjacentes foram removidos após autorização; não estão no inventário atual.

| Caminho concreto | Bytes | Categoria da revisão | Evidência |
|---|---:|---|---|
| `res://assets/Sprites-v3/boy-a/boy-a-dormindo.png` | 95496 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m0-s.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m0.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m1-s.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m1.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m2-s.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m2.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m3-s.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m3.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m4-s.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m4.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m5-s.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-m5.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r1-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m0-s.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m0.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m1-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m1.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m2-s.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m2.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m3-s.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m3.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m4-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m4.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m5-s.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-m5.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-a/boy-a-r2-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-dormindo.png` | 99351 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m0-s.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m0.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m1-s.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m1.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m2-s.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m2.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m3-s.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m3.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m4-s.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m4.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m5-s.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-m5.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r1-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m0-s.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m0.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m1-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m1.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m2-s.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m2.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m3-s.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m3.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m4-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m4.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m5-s.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-m5.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/boy-b/boy-b-r2-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-dormindo.png` | 113606 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m0-s.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m0.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m1-s.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m1.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m2-s.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m2.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m3-s.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m3.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m4-s.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m4.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m5-s.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-m5.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r1-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m0-s.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m0.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m1-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m1.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m2-s.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m2.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m3-s.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m3.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m4-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m4.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m5-s.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-m5.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-a/girl-a-r2-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-dormindo.png` | 115236 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m0-s.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m0.png` | 1134478 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m1-s.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m1.png` | 1160179 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m2-s.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m2.png` | 1115297 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m3-s.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m3.png` | 1076465 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m4-s.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m4.png` | 1112374 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m5-s.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-m5.png` | 1141655 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r1-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m0-s.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m0.png` | 1028117 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m1-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m1.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m2-s.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m2.png` | 995743 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m3-s.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m3.png` | 993612 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m4-s.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m4.png` | 1053782 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m5-s.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-m5.png` | 1118330 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-sentado-s.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-b/girl-b-r2-sentado.png` | 1056721 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/girl-banho/walk banho.png` | 211009 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-a-dormindo.png` | 553039 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-a-head.png` | 571460 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-a-head_rain.png` | 777077 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-b-dormindo.png` | 522805 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-b-head.png` | 539032 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/boy-b-head_rain.png` | 750444 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-a-dormindo.png` | 708049 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-a-head.png` | 733727 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-a-head_rain.png` | 958915 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-b-dormindo.png` | 464497 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-b-head.png` | 484187 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/heads/girl-b-head_rain.png` | 662059 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |
| `res://assets/Sprites-v3/sujeira 0.png` | 20191 | Removido; CSV anterior: Uso incerto | Fora dos 24 caminhos do único carregador da pasta; sem consumidor literal |

## Validação após a limpeza

Removidos 130 PNGs (129.158.228 bytes / 123,175 MiB) e 130 metadados adjacentes (98.944 bytes), individualmente após conferir caminhos absolutos dentro de `assets/Sprites-v3/`. Preservados os 24 PNGs de banho, seus metadados e os dois metadados órfãos preexistentes. Inventário regenerado com 2.739 assets; `--self-check` e `--check` passaram. As 13 referências ausentes do scanner permaneceram exatamente iguais ao baseline. Em Godot `3.3.4.stable.official.faf3f883d`, check temporário de `Load_Plataform()` para boy/girl verificou as 24 texturas não nulas e caminhos exatos dos frames 0–5 limpos/sujos; passou com código 0. O check temporário foi removido e não gravou saves. Apenas aviso de oversampling de fonte; conferência visual e exportação/APK pendentes.
