# Mapa de assets e sistema de save

Levantamento do AF-Game26 em 01/10/2026, atualizado após as limpezas autorizadas registradas ao final deste documento. Os saves e os presets de exportação foram preservados.

## Como consultar e reproduzir

- [Inventário CSV](inventario_assets.csv): uma linha por asset-fonte, com caminho `res://`, tamanho em bytes, classificação, referências e contexto de cena/nó/propriedade.
- Execute `python tools/inventory_assets.py --self-check`, depois `python tools/inventory_assets.py` para atualizar as tabelas e o CSV. `python tools/inventory_assets.py --check` verifica os entregáveis sem reescrevê-los. Python 3.10 ou superior, somente biblioteca padrão.
- O rastreamento parte de `run/main_scene` (`src/Landing_Page_Temp.tscn`), autoloads, ícone, ambiente e layout padrão de áudio. Segue referências literais em cenas, recursos, scripts e JSONs, além de dependências de classes GDScript.
- Referências em sub-recursos são associadas aos nós consumidores, inclusive materiais, temas e animações. Para recursos sem nó consumidor identificado, a origem da declaração permanece no CSV.
- Comentários GDScript/shader e documentação não comprovam uso. Registros globais de classes não são tratados como entradas de execução: a classe entra quando mencionada por código alcançável.
- Expansões finitas de `CharacterController` resolvem `FACE_IDS`, cabeças básicas/sem rosto, sono, roupas e banho para ambos os gêneros, cabelos e roupas, além dos sete frames de chuva/neve. Essas regras estão no gerador e precisam acompanhar mudanças no código; expressões de cabeças por emoção e concatenações legadas de Hidratona permanecem conservadoras.

### Significado das categorias

| Categoria | Interpretação |
|---|---|
| Jogo atual | Dependência alcançável estaticamente, literal ou dinâmica resolvida. Não significa que todo ramo foi executado ou todo nó esteve visível. |
| Testes/protótipos | Referência somente em scripts/cenas/recursos fora do grafo atual; inclui ferramentas e material legado. |
| Uso incerto | Arquivo que corresponde a um prefixo dinâmico do jogo; não há prova suficiente de que o nome específico seja carregado. |
| Sem referência encontrada | Nenhum vínculo encontrado pelo levantamento; candidato à revisão, não autorização de remoção. |

O inventário cobre imagens, áudio, fontes, cenas, recursos, shaders, JSON, vídeos, modelos e formatos de trabalho/arquivos compactados conhecidos, em qualquer pasta; inclui a extensão atípica `.png1` existente no projeto. Código, documentos, executáveis, caches e builds não entram na soma de assets-fonte. Arquivos de formatos inventariados em pastas de ferramentas também aparecem, mesmo que não sejam usados no jogo. Metadados `.import` são contabilizados separadamente. Projetos aninhados são identificados nas observações e seus caminhos `res://` são resolvidos relativamente à raiz própria; suas dependências não tornam um asset parte do jogo principal.

O scanner não executa GDScript: referências em funções não chamadas e recursos declarados sem uso podem superestimar o jogo atual. Expressões construídas sem um prefixo `res://`, caminhos externos, recursos binários `.res`/`.scn`, arquivos compactados e descoberta em runtime precisam de revisão manual. Arquivos binários e compactados são inventariados, mas seu conteúdo não é interpretado. Não há prova geral de ausência de uso.

Os presets Android, Windows e HTML5 usam `export_filter="all_resources"`. Android/Windows incluem `*json`; Windows também exclui algumas pastas de build/ferramentas. Um recurso fora do fluxo pode continuar no pacote. Tamanho-fonte não equivale à economia no APK: importação, compressão, arquiteturas e filtros influenciam o resultado. Nenhum filtro foi alterado.

<!-- BEGIN INVENTARIO GERADO -->
## Resultado do rastreamento estático

Gerado por `tools/inventory_assets.py`; tamanhos dos arquivos-fonte, em MiB (1.048.576 bytes).

| Classificação | Arquivos | MiB |
|---|---:|---:|
| Jogo atual | 748 | 338.97 |
| Testes/protótipos | 84 | 1.53 |
| Uso incerto | 1389 | 47.43 |
| Sem referência encontrada | 505 | 43.84 |
| **Total** | **2726** | **431.77** |

### Por pasta e classificação

| Pasta | Classificação | Arquivos | MiB |
|---|---|---:|---:|
| `(raiz)` | Jogo atual | 4 | 0.01 |
| `(raiz)` | Sem referência encontrada | 1 | 0.01 |
| `.claude` | Sem referência encontrada | 1 | 0.00 |
| `.vscode` | Sem referência encontrada | 1 | 0.00 |
| `assets` | Jogo atual | 3 | 2.54 |
| `assets` | Sem referência encontrada | 6 | 1.99 |
| `assets/All_Character_Sprites` | Jogo atual | 33 | 1.50 |
| `assets/All_Character_Sprites` | Uso incerto | 1254 | 33.94 |
| `assets/Alongamento` | Jogo atual | 6 | 7.42 |
| `assets/Alongamento` | Sem referência encontrada | 50 | 5.58 |
| `assets/Character_Creator` | Jogo atual | 26 | 2.93 |
| `assets/Character_Creator` | Sem referência encontrada | 14 | 1.00 |
| `assets/DoiAqui` | Jogo atual | 37 | 2.07 |
| `assets/DoiAqui` | Sem referência encontrada | 83 | 4.00 |
| `assets/DoiAqui` | Testes/protótipos | 7 | 0.05 |
| `assets/DoiAqui` | Uso incerto | 66 | 0.60 |
| `assets/Hidratona` | Jogo atual | 36 | 0.68 |
| `assets/Hidratona` | Sem referência encontrada | 36 | 0.88 |
| `assets/Hidratona` | Testes/protótipos | 2 | 0.32 |
| `assets/Hidratona` | Uso incerto | 13 | 0.07 |
| `assets/HospitalBackgroundImage` | Jogo atual | 1 | 0.91 |
| `assets/HospitalBackgroundImage` | Sem referência encontrada | 5 | 1.64 |
| `assets/MapAssets` | Jogo atual | 1 | 0.07 |
| `assets/Match-3` | Jogo atual | 75 | 4.91 |
| `assets/Match-3` | Sem referência encontrada | 9 | 1.30 |
| `assets/Match-3` | Testes/protótipos | 5 | 0.54 |
| `assets/Match-3` | Uso incerto | 24 | 0.77 |
| `assets/MiniGame_Escovar` | Jogo atual | 5 | 1.91 |
| `assets/Minigame_LavarMaos` | Jogo atual | 2 | 0.43 |
| `assets/NEW-TelaTitulo` | Jogo atual | 1 | 0.12 |
| `assets/NEW-TelaTitulo` | Sem referência encontrada | 3 | 0.53 |
| `assets/Nova pasta` | Jogo atual | 8 | 0.08 |
| `assets/Particulas` | Jogo atual | 4 | 0.47 |
| `assets/Particulas` | Sem referência encontrada | 133 | 9.07 |
| `assets/Particulas` | Testes/protótipos | 10 | 0.15 |
| `assets/Plataforma` | Jogo atual | 108 | 28.15 |
| `assets/Plataforma` | Sem referência encontrada | 100 | 11.24 |
| `assets/Plataforma` | Testes/protótipos | 16 | 0.31 |
| `assets/Sprites-v3` | Jogo atual | 24 | 4.85 |
| `assets/SpritesV4` | Jogo atual | 108 | 47.72 |
| `assets/SpritesV4` | Uso incerto | 32 | 12.06 |
| `assets/fonts` | Jogo atual | 3 | 0.29 |
| `assets/fonts` | Testes/protótipos | 3 | 0.00 |
| `assets/hospital` | Jogo atual | 4 | 0.01 |
| `data/character` | Jogo atual | 22 | 0.01 |
| `src` | Jogo atual | 12 | 0.96 |
| `src` | Testes/protótipos | 2 | 0.02 |
| `src/Assets` | Jogo atual | 87 | 217.56 |
| `src/Assets` | Sem referência encontrada | 7 | 0.89 |
| `src/Audio` | Jogo atual | 2 | 0.01 |
| `src/Mini-games` | Jogo atual | 90 | 6.97 |
| `src/Mini-games` | Sem referência encontrada | 46 | 4.95 |
| `src/Mini-games` | Testes/protótipos | 23 | 0.10 |
| `src/Tools` | Testes/protótipos | 1 | 0.02 |
| `src/UI` | Jogo atual | 46 | 6.39 |
| `src/UI` | Sem referência encontrada | 10 | 0.76 |
| `src/UI` | Testes/protótipos | 7 | 0.02 |
| `tests` | Testes/protótipos | 8 | 0.00 |

### Maiores candidatos à revisão

| Caminho | Classificação | MiB |
|---|---|---:|
| `res://assets/All_Character_Sprites/Girl/pardo/hidratona-GIRL/boy-win-girl.png` | Uso incerto | 1.11 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m5-s.png` | Uso incerto | 1.07 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m5.png` | Uso incerto | 1.07 |
| `res://assets/Plataforma/rooms/room-quintal.png` | Sem referência encontrada | 1.06 |
| `res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/snow/rs_d.png` | Uso incerto | 1.03 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m1-s.png` | Uso incerto | 1.00 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m1.png` | Uso incerto | 1.00 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m4-s.png` | Uso incerto | 1.00 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m4.png` | Uso incerto | 1.00 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m0-s.png` | Uso incerto | 0.98 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m0.png` | Uso incerto | 0.98 |
| `res://assets/Plataforma/rooms/room-banheiro.png` | Sem referência encontrada | 0.97 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m2-s.png` | Uso incerto | 0.95 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m2.png` | Uso incerto | 0.95 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m3-s.png` | Uso incerto | 0.95 |
| `res://assets/SpritesV4/RoupasNormais/Menina/Variacao2/m3.png` | Uso incerto | 0.95 |
| `res://assets/Plataforma/rooms/bathroom.png` | Sem referência encontrada | 0.93 |
| `res://assets/Plataforma/rooms/room-banheiro-2.png` | Sem referência encontrada | 0.93 |
| `res://assets/Plataforma/rooms/living-room.png` | Sem referência encontrada | 0.91 |
| `res://assets/Particulas/materials/blend_file/particles.blend` | Sem referência encontrada | 0.91 |
| `res://assets/Plataforma/Sprites Barra de Status + navegacao/Barra de Status + UI (v2.2) referência 2.jpg` | Sem referência encontrada | 0.87 |
| `res://assets/Plataforma/Sprites Barra de Status + navegacao/Barra de Status + UI (v2.2) referência 1.jpg` | Sem referência encontrada | 0.87 |
| `res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/snow/rs_1.png` | Uso incerto | 0.87 |
| `res://src/Mini-games/Hidratona/src/level/snow/rs_1.png` | Sem referência encontrada | 0.87 |
| `res://assets/Plataforma/bubble.png` | Sem referência encontrada | 0.87 |

### Maiores assets do jogo atual

| Caminho | MiB |
|---|---:|
| `res://src/Assets/Audio/Music/hospital_lofi.wav` | 84.96 |
| `res://src/Assets/Audio/Music/title_menu.wav` | 37.68 |
| `res://src/Assets/Audio/SFX/Home/birds_wide.wav` | 15.38 |
| `res://src/Assets/Audio/SFX/Minigames/Hidratona/bird_call.wav` | 13.00 |
| `res://src/Assets/Audio/Music/home_theme.wav` | 10.90 |
| `res://src/Assets/Audio/SFX/Minigames/Hidratona/snow.wav` | 10.53 |
| `res://src/Assets/Audio/Music/alongamento.mp3` | 8.69 |
| `res://src/Assets/Audio/SFX/Home/rain_ambience.wav` | 8.48 |
| `res://src/Assets/Audio/SFX/Home/forest_ambience.wav` | 7.69 |
| `res://src/Assets/Audio/Music/meditacao.mp3` | 7.48 |

### Armazenamento separado

Estes arquivos não entram no total de assets-fonte acima; `.git` não foi medido.

| Área | MiB |
|---|---:|
| `.import` | 753.56 |
| `android` | 79.89 |
| `output` | 364.89 |
| Metadados `.import` (2751 arquivos) | 1.96 |

Projetos aninhados: `assets/Particulas/src`.

### Padrões e carregamentos dinâmicos no jogo

Prefixos mantêm candidatos como uso incerto. Chamadas sem prefixo exigem leitura do produtor do caminho; referências literais e catálogos alcançáveis já entram no grafo.

| Origem | Expressão / padrão |
|---|---|
| `res://src/Audio/AudioSettings.gd:23` | `var loaded = config.load(SETTINGS_PATH) == OK` |
| `res://src/Audio/VoiceManager.gd:17` | `func play_path(path: String) -> bool:` |
| `res://src/Audio/VoiceManager.gd:26` | `var stream = load(path)` |
| `res://src/Audio/VoiceManager.gd:47` | `return play_path(path)` |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/%s.png` |
| `res://src/CharacterController.gd:33` | `return load(path) as Texture if ResourceLoader.exists(path) else null` |
| `res://src/CharacterController.gd:215` | `res://assets/SpritesV4/Cabecas/%s/%s1.png` |
| `res://src/CharacterController.gd:217` | `return load(happy_head) as Texture` |
| `res://src/CharacterController.gd:220` | `res://assets/SpritesV4/Cabecas/%s/%s-%s.png` |
| `res://src/CharacterController.gd:222` | `return load(path) as Texture` |
| `res://src/CharacterController.gd:228` | `res://assets/SpritesV4/Cabecas/%s/%s.png` |
| `res://src/CharacterController.gd:233` | `res://assets/SpritesV4/Cabecas/%s/%s_noface.png` |
| `res://src/CharacterController.gd:281` | `res://assets/SpritesV4/RoupasNormais/%s/%s/` |
| `res://src/CharacterController.gd:283` | `plataform.idle = load(normal_path + ("girlsc-1-1.png" if new_girl_variation else "m0.png"))` |
| `res://src/CharacterController.gd:284` | `plataform.idle_dirty = plataform.idle if new_girl_variation else load(normal_path + "m0-s.png")` |
| `res://src/CharacterController.gd:285` | `plataform.seated = load(normal_path + "sentado.png")` |
| `res://src/CharacterController.gd:286` | `plataform.seated_dirty = load(normal_path + "sentado-s.png")` |
| `res://src/CharacterController.gd:289` | `plataform.walk[key] = load(normal_path + ("girlsc-1-%d.png" % (frame + 1) if new_girl_variation else "m%d.png" % frame))` |
| `res://src/CharacterController.gd:290` | `plataform.walk_dirty[key] = plataform.walk[key] if new_girl_variation else load(normal_path + "m%d-s.png" % frame)` |
| `res://src/CharacterController.gd:293` | `res://assets/SpritesV4/RoupasNormais/%s/dormindo-%s.png` |
| `res://src/CharacterController.gd:296` | `res://assets/Sprites-v3/%s-banho/%s-banho-` |
| `res://src/CharacterController.gd:297` | `plataform.idle_bath = load(bath_path + "m0.png")` |
| `res://src/CharacterController.gd:298` | `plataform.idle_bath_dirty = load(bath_path + "m0-s.png")` |
| `res://src/CharacterController.gd:301` | `plataform.bath[bath_key] = load(bath_path + "m%d.png" % bath_frame)` |
| `res://src/CharacterController.gd:302` | `plataform.bath_dirty[bath_key] = load(bath_path + "m%d-s.png" % bath_frame)` |
| `res://src/CharacterController.gd:422` | `res://assets/All_Character_Sprites/` |
| `res://src/CharacterController.gd:427` | `hidratona.run.r1 = load(str(path, "correr-1.png"))` |
| `res://src/CharacterController.gd:428` | `hidratona.run.r2 = load(str(path, "correr-2.png"))` |
| `res://src/CharacterController.gd:429` | `hidratona.run.r3 = load(str(path, "correr-3.png"))` |
| `res://src/CharacterController.gd:430` | `hidratona.run.r4 = load(str(path, "correr-4.png"))` |
| `res://src/CharacterController.gd:431` | `hidratona.run.r5 = load(str(path, "correr-5.png"))` |
| `res://src/CharacterController.gd:432` | `hidratona.run.r6 = load(str(path, "correr-6.png"))` |
| `res://src/CharacterController.gd:433` | `hidratona.run.r7 = load(str(path, "correr-7.png"))` |
| `res://src/CharacterController.gd:435` | `hidratona.fall = load(str(path, "caindo-buraco.png"))` |
| `res://src/CharacterController.gd:439` | `hidratona.rain.fall = load(str(path, "rain/rc_fall.png"))` |
| `res://src/CharacterController.gd:440` | `hidratona.rain.win = load(str(path, "rain/rc_win.png"))` |
| `res://src/CharacterController.gd:443` | `hidratona.snow.fall = load(str(path, "snow/rs_fall.png"))` |
| `res://src/CharacterController.gd:444` | `hidratona.snow.win = load(str(path, "snow/rs_win.png"))` |
| `res://src/CharacterController.gd:449` | `hidratona.run.r1 = load(str(path, "correr-1-girl.png"))` |
| `res://src/CharacterController.gd:450` | `hidratona.run.r2 = load(str(path, "correr-2-girl.png"))` |
| `res://src/CharacterController.gd:451` | `hidratona.run.r3 = load(str(path, "correr-3-girl.png"))` |
| `res://src/CharacterController.gd:452` | `hidratona.run.r4 = load(str(path, "correr-4-girl.png"))` |
| `res://src/CharacterController.gd:453` | `hidratona.run.r5 = load(str(path, "correr-5-girl.png"))` |
| `res://src/CharacterController.gd:454` | `hidratona.run.r6 = load(str(path, "correr-6-girl.png"))` |
| `res://src/CharacterController.gd:455` | `hidratona.run.r7 = load(str(path, "correr-7-girl.png"))` |
| `res://src/CharacterController.gd:457` | `hidratona.fall = load(str(path, "cair-buraco-girl.png"))` |
| `res://src/CharacterController.gd:458` | `hidratona.win = load(str(path, "girl-win.png"))` |
| `res://src/CharacterController.gd:461` | `hidratona.rain.fall = load(str(path, "rain/rc_fall.png"))` |
| `res://src/CharacterController.gd:462` | `hidratona.rain.win = load(str(path, "rain/rc_win.png"))` |
| `res://src/CharacterController.gd:465` | `hidratona.snow.fall = load(str(path, "snow/rs_fall.png"))` |
| `res://src/CharacterController.gd:466` | `hidratona.snow.win = load(str(path, "snow/rs_win.png"))` |
| `res://src/CharacterController.gd:470` | `res://assets/SpritesV4/RoupasEspeciais/Chuva/Correndo/boy_rc_%d.png` |
| `res://src/CharacterController.gd:471` | `res://assets/SpritesV4/RoupasEspeciais/Neve/Correndo/correrneve-%d.png` |
| `res://src/Mini-games/DoiAqui/actor/Player.gd:6` | `var outfit_tuning = preload(TUNING_PATH)` |
| `res://src/Mini-games/DoiAqui/actor/Player.gd:10` | `res://assets/SpritesV4/DoiAqui/` |
| `res://src/Mini-games/DoiAqui/actor/Player.gd:60` | `body_sprite.texture = load(_body_texture_path(state_name)) as Texture` |
| `res://src/Mini-games/DoiAqui/actor/Player.gd:132` | `$sprite.texture = load(_body_texture_path("parado")) as Texture` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:29` | `res://src/Assets/Audio/Voice/Minigames/DoiAqui/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:79` | `res://assets/DoiAqui/sprites/tratamento/pain/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:197` | `res://assets/DoiAqui/sprites/tratamento/about/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:237` | `res://assets/DoiAqui/sprites/tratamento/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:238` | `res://assets/DoiAqui/sprites/tratamento/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:245` | `res://assets/DoiAqui/sprites/notratamento/` |
| `res://src/Mini-games/DoiAqui/scene/Main.gd:246` | `res://assets/DoiAqui/sprites/notratamento/` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:9` | `res://assets/Hidratona/sprites/HidratonaNewTest/` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:474` | `$AllSprites/r1.texture = load(path + "correr-1-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:475` | `$AllSprites/r2.texture = load(path + "correr-2-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:476` | `$AllSprites/r3.texture = load(path + "correr-3-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:477` | `$AllSprites/r4.texture = load(path + "correr-4-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:478` | `$AllSprites/r5.texture = load(path + "correr-5-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:479` | `$AllSprites/r6.texture = load(path + "correr-6-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:480` | `$AllSprites/r7.texture = load(path + "correr-7-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:481` | `$AllSprites/j1.texture = load(path + "pular-1-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:482` | `$AllSprites/j2.texture = load(path + "pular-2-girl.png")` |
| `res://src/Mini-games/Hidratona/src/Actor/Player.gd:483` | `$AllSprites/squat.texture = load(path + "agachar.png")` |
| `res://src/Mini-games/Match-3/src/GUI/Blocked_Fruit_UI.gd:17` | `$icon.texture = load(fruit.sprite)` |
| `res://src/Mini-games/Match-3/src/GUI/Blocked_Fruit_UI.gd:33` | `$icon.texture = load(fruit.sprite)` |
| `res://src/Mini-games/Match-3/src/GUI/Fruit_UI.gd:20` | `$icon.texture = load(fruit.sprite)` |
| `res://src/Mini-games/Match-3/src/GUI/Fruit_UI.gd:41` | `$icon.texture = load(fruit.sprite)` |
| `res://src/Mini-games/Match-3/src/GUI/Fruit_UI.gd:53` | `$icon.texture = load(fruit.sprite)` |
| `res://src/Mini-games/Match-3/src/GUI/Show_Which_Fruit.gd:35` | `res://assets/Match-3/sprites/` |
| `res://src/Mini-games/Match-3/src/Levels/Win.gd:116` | `res://assets/Match-3/sprites/` |
| `res://src/Mini-games/Match-3/src/Score.gd:47` | `res://assets/Match-3/sprites/` |
| `res://src/UI/Dialog.gd:154` | `VoiceManager.play_path(_current_voice_path)` |
| `res://src/UI/Rooms/Bathroom.gd:125` | `var minigame = load(minigame_path).instance()` |

### Referências literais sem arquivo correspondente

Inclui todos os contextos analisados. Caminhos de pastas/padrões ficam na seção dinâmica. Não são falhas comprovadas em execução.

| Origem | Caminho | Contexto |
|---|---|---|
| `res://assets/DoiAqui/fonts/raleway-end.tres:3` | `res://assets/fonts/Raleway/static/Raleway-SemiBold.ttf` | Fora do fluxo atual |
| `res://assets/DoiAqui/fonts/red-raleway.tres:3` | `res://assets/fonts/Raleway/static/Raleway-Black.ttf` | Fora do fluxo atual |
| `res://assets/DoiAqui/fonts/xolonium_64.tres:3` | `res://assets/fonts/Xolonium-Regular.ttf` | Fora do fluxo atual |
| `res://assets/fonts/Potta.tres:3` | `res://assets/fonts/PottaOne-Regular.ttf` | Fora do fluxo atual |
| `res://assets/fonts/xolonium_64.tres:3` | `res://assets/fonts/Xolonium-Regular.ttf` | Fora do fluxo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/bravo.png` | Jogo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/dor.png` | Jogo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/dormindo.png` | Jogo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/feliz.png` | Jogo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/neutro.png` | Jogo atual |
| `res://src/CharacterController.gd:6` | `res://assets/SpritesV4/Feicoes/triste.png` | Jogo atual |
| `res://src/Mini-games/Hidratona/src/temp/Main.tscn:3` | `res://scripts/ObstacleManager.gd` | Fora do fluxo atual |
| `res://src/TestScene.tscn:3` | `res://src/TestScene.gd` | Fora do fluxo atual |

<!-- END INVENTARIO GERADO -->

## Mapa do sistema de save

### Caminhos e resolução

`res://` aponta para os arquivos do projeto/pacote. `user://` aponta para a área gravável do aplicativo; não é uma pasta de assets dentro deste repositório. A resolução pode ser conferida no Godot com `ProjectSettings.globalize_path("user://")` ou `OS.get_user_data_dir()`.

No Windows, com `application/config/name="Sickle Cell Anemia"` e sem configuração de diretório personalizado, o caminho local confirmado por leitura da pasta foi `C:/Users/Lima/AppData/Roaming/Godot/app_userdata/Sickle Cell Anemia/`. Em 01/10/2026 estavam presentes `savegame.save` (392 bytes), `plant_care.save` (192 bytes), `audio_settings.cfg` (50 bytes), `doi_test_tuning.tres` (643 bytes) e `logs/`. Nenhum conteúdo ou arquivo de save foi alterado para este levantamento.

No Android, `user://` usa armazenamento privado do aplicativo. O preset declara o pacote `com.aventuras.falciforme`; não há dispositivo conectado verificado neste levantamento, portanto nenhum caminho absoluto Android foi confirmado. Usar a resolução do próprio Godot no dispositivo; não codificar um caminho do Windows ou presumir acesso via gerenciador de arquivos. HTML5 usa persistência virtual do navegador, não a pasta do Windows.

### Save principal — `user://savegame.save`

Responsável: `src/SaveController.gd`, autoload `SaveController`. Formato: um objeto JSON por linha, não um único array JSON. `filename` é o identificador lógico do registro, não o caminho de uma cena.

| Registro / produtor no grupo `Persist` | Campos persistidos | Valores iniciais / compatibilidade |
|---|---|---|
| `NecessityManager` / `src/NecessityBars.gd` | `higiene`, `bexiga`, `fome`, `diversao`, `energia` | Inicialmente zero. Os cinco campos são obrigatórios na leitura. |
| `CharacterController` / `src/CharacterController.gd` | `boyorgirl`, `glass`, `variation` | `Boy`, `false`, `1`. Todos obrigatórios na leitura. |
| `AnimationController` / `src/AnimationController.gd` | `status` | `Started`; obrigatório na leitura. |
| `NewCharData` / `src/UI/new_char_data.gd` | `cabelo`, `genero`, `cor_pele`, `tom_pele_id`, `roupa`, `cor_roupa_cima`, `cor_roupa_baixo` | Strings inicialmente vazias. `tom_pele_id` é opcional para saves antigos e assume `""`; os demais campos são obrigatórios. |

Fluxo de gravação: `SaveController._notification()` chama `save_game()` ao sair, ao voltar pelo sistema e ao perder foco. O seletor de roupas também grava explicitamente. `save_game(path)` aceita outro caminho para testes. Não grava se cabelo, gênero, cor da pele ou roupa estiverem vazios; falha ao abrir também retorna sem gravar. Itera os nós de `Persist`, chama `save()` e escreve uma linha para cada registro; nós sem esse método são ignorados com mensagem. O arquivo é aberto com `File.WRITE`, substituindo o anterior, sem escrita atômica ou backup.

Fluxo de leitura: a tela `Landing_Page_Temp` desabilita Continuar somente quando o arquivo não existe. Ao clicar, espera o som do botão e chama `load_game()`. A leitura indexa os registros por `filename`, independentemente da ordem; em duplicatas, o último registro vence. Linhas vazias são ignoradas; linhas inválidas ou sem `filename` não entram no índice. Ausência de arquivo, falha ao abrir, registros/campos obrigatórios ausentes retornam `false`, mantendo o usuário na tela inicial. Não há versão de schema nem validação geral dos tipos/intervalos dos valores. A validação dos campos ocorre antes de aplicar os registros.

Ao carregar, restaura necessidades e escolhas, chama `GlobalResource.set_gender()`, aplica o estado de animação e os dados de `NewCharData`, e executa `CharacterController.start()`. Em sucesso, a tela marca `NecessityBars.started=true` e abre `src/UI/Loading.tscn`, que carrega `src/MainScreen.tscn`. A localização exata do jogador/quarto não é persistida pelo schema atual.

**Dependências de assets do save:** gênero (`boy`/`girl`), cabelo (`a`/`b`) e roupa (`r1`/`r2`) determinam cabeças, corpos, caminhada, banho e sono. `tom_pele_id` é resolvido no catálogo modular; cores alimentam shaders. Os catálogos `data/character/DT_*.tres` e fallbacks de `ModularCharacterData` continuam necessários mesmo que a seleção inicial não os mostre. Não remover versões de sprites apenas por terem nomes antigos: `Load_Plataform()` ainda usa `assets/Sprites-v3` para banho, e outros ramos de `CharacterController` referenciam `All_Character_Sprites`. Padrões não resolvidos ficam explicitamente como uso incerto no inventário.

### Jardim — `user://plant_care.save`

Responsáveis: `src/Mini-games/PlantCare/PlantCareMenu.gd`, `PlantSlot.gd` e `PlantData.gd`. Formato: objeto JSON com `version=1`, `coins`, `unlocked_slots` e `slots`. Cada slot com planta contém `plant_id`, `stage`, `water_progress`, `cooldown_until`; slot vazio é `{}`. O cooldown usa timestamp Unix.

Na entrada do menu, configura os oito slots e o catálogo de cinco plantas, inicia moedas em `initial_coins=100`, carrega o save e atualiza a interface. Sem arquivo, falha ao abrir, JSON não dicionário ou versão diferente de 1 deixam o estado inicial. Moedas são limitadas a mínimo zero; os dois primeiros slots permanecem desbloqueados. Arrays ausentes/inválidos ou slots sem `plant_id` são ignorados. `plant_id` desconhecido não restaura planta. `restore()` limita estágio a 0–3, água a 0–1 e cooldown a mínimo zero.

Grava após plantio, compra de slot, venda e alterações de rega/estágio; também ao voltar e ao sair da árvore, quando `_loaded` está ativo. Sem slots, não grava. Abertura para escrita que falha não gera mensagem; não há backup/escrita atômica. O nome da planta salvo seleciona o recurso no `plant_catalog` exportado pela cena; `stage_sprites` e `icon` determinam a textura, com fallback para `icon`. Todos os estágios do catálogo são dependências, inclusive os que ainda não aparecem no jardim inicial. Estágios a partir de 2 criam material com `flower_tint.shader`.

### Áudio — `user://audio_settings.cfg`

Responsável: autoload `src/Audio/AudioSettings.gd`. Formato `ConfigFile`, seção `[audio]`, chaves `Master`, `Music`, `SFX`, `Voice`, com valores lineares entre 0 e 1. `load_settings()` roda em `_ready()`; arquivo ausente/erro usa 1.0 por bus, campos ausentes também usam 1.0, valores são limitados a 0–1. O áudio é aplicado imediatamente: zero silencia, demais valores viram dB.

Mover sliders atualiza os buses em memória; fechar o painel (`AudioSettingsPanel.close()`) ou sair pelo sistema grava o arquivo. Erro ao salvar usa `push_error`; bus desconhecido ou ausente produz aviso. Não armazena caminhos de músicas, efeitos ou dublagem: esses assets vêm de cenas/scripts/JSONs e do layout de buses.

### Persistência e arquivos exclusivos de testes

| Teste | Caminho / tratamento |
|---|---|
| `test_character_save.gd` | `user://test_character_save.save`; usa o parâmetro de caminho de `SaveController` e remove o arquivo ao concluir. |
| `test_plant_care_garden.gd` | Altera o nome do aplicativo para `PlantCareGardenTest`; usa `user://plant_care.save` nessa área separada e remove o arquivo de teste. |
| `test_bedroom_clothes.gd` | Usa `user://savegame.save`; preserva/restaura conteúdo anterior ou remove o criado pelo teste. Não foi executado neste levantamento. |
| `test_android_regressions.gd` | `user://android-voice-%d.tres` temporário; captura PNG opcional no caminho definido por `ANDROID_CAPTURE`. |
| `test_hidratona_run.gd` | `user://hidratona-calibration-test.tres` temporário. |
| `test_doi_aqui_confirm.gd` | `user://doi_test_tuning.tres`; um exemplar permanece na área local confirmada. |

## Conferência manual e limites para limpeza

- **Hospital:** `SlotsHospital.gd` instancia as quatro salas; elas referenciam `Dialog.tscn`, cujo `VoiceButton` usa `speak.png`. `json_path` liga cada sala a `assets/hospital/*/dialogo.json`; as chaves `voice` ligam falas aos `.ogg` em `src/Assets/Audio/Voice/Hospital`.
- **Casa:** `Landing_Page_Temp.gd → Loading.gd → MainScreen.tscn`; os scripts de slots/rooms e seus `preload`/`load` levam às salas e aos minigames, inclusive instâncias abertas sob demanda no banheiro.
- **Personagem:** `CharacterController` e `ModularCharacterData` são autoloads. Referências nos catálogos `.tres` são indiretas; os caminhos montados com gênero, cabelo, roupa e frame exigem proteger variações e fallbacks.
- **Minigames:** no jardim, `PlantCareMenu.tscn → plant_catalog → PlantData → stage_sprites`; no Match-3, scripts de tabuleiro e cenas de frutas levam a texturas e UI; JSON de hospital comprova um caso de áudio que não está diretamente atribuído a um nó da cena.

A verificação do gerador cobre ciclos, dependências indiretas, contexto de sub-recursos, comentários, nomes com espaços/vírgulas, projetos aninhados, expansão de expressões finitas e prefixos dinâmicos. A verificação dos entregáveis compara o CSV regenerado, existência dos caminhos e resumo de contagem/tamanho. Não executa o jogo nem os testes Godot que podem gravar saves. Antes de uma futura exclusão, revisar usos incertos e validar as opções de personagem, salas e minigames no jogo e na exportação; não usar este documento como lista automática de remoção.
## Limpeza de 01/10/2026

Removidos os 25 arquivos da seção anterior de maiores candidatos à revisão, por solicitação do usuário, e seus metadados .import. Essa lista é fixa: atualizar o inventário não autoriza apagar os novos candidatos.

Redução de 65,90 MiB nos arquivos-fonte e 19 metadados removidos. Caches `.import`, histórico Git e builds não foram apagados; a redução não representa uma medição do APK. Inventário regenerado e verificado com 3.737 assets restantes. A remoção da fonte deixou uma referência residual em `assets/fonts/Potta.tres`, fora do fluxo atual, registrada na tabela de referências sem arquivo. Não foi executado o jogo.

As três cópias boy-win.png em Boy/branco, Boy/negro e Boy/pardo eram idênticas à cópia mantida em assets/All_Character_Sprites/Boy/hidratona-BOY/boy-win.png (SHA-256 DD06A7A861FA4455E51E38FBE179A27A9F20B34AC5A47ACD7970D2E04FDEB983). CharacterController.Load_Hidratona agora carrega essa cópia compartilhada.

Arquivos removidos:

- res://sprites_andar_e_correr.zip
- res://assets/Sprites-v3/boy-a.7z
- res://assets/DoiAqui/fonts/PottaOne-Regular.ttf
- res://assets/fonts/PottaOne-Regular.ttf
- res://src/Assets/Audio/Music/doiaqui_theme.wav
- res://assets/Particulas/textures/effects-examples.gif
- res://src/PlantIcon.png
- res://assets/Hidratona/sprites/HidratonaNewTest/boy-win-girl.png
- res://assets/All_Character_Sprites/Girl/hidratona-GIRL.7z
- res://src/Mini-games/Hidratona/src/level/heads/boy-b.png
- res://src/Mini-games/Hidratona/src/level/heads/girl-b.png
- res://src/Mini-games/Hidratona/src/level/heads/boy-a.png
- res://assets/DoiAqui/sprites/actor/boy/boy-a-head-triste.png
- res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/snow/rs_2.png
- res://sprites_andar_e_correr/Correr/neve/branco/boy_rs_2.png
- res://src/Mini-games/Hidratona/src/level/snow/rs_2.png
- res://assets/All_Character_Sprites/Boy/New_Character_Sprites/Boy-branco/boy-win.png
- res://assets/All_Character_Sprites/Boy/New_Character_Sprites/Girl-branca/boy-win-girl.png
- res://assets/All_Character_Sprites/Boy/New_Character_Sprites/Girl-parda/boy-win-girl.png
- res://assets/All_Character_Sprites/Boy/branco/hidratona-BOY/boy-win.png
- res://assets/All_Character_Sprites/Boy/negro/hidratona-BOY/boy-win.png
- res://assets/All_Character_Sprites/Boy/pardo/hidratona-BOY/boy-win.png
- res://assets/All_Character_Sprites/Girl/branco/hidratona-GIRL/boy-win-girl.png
- res://assets/All_Character_Sprites/Girl/hidratona-GIRL/boy-win-girl.png
- res://assets/All_Character_Sprites/Girl/negro/hidratona-GIRL/boy-win-girl.png


## Limpeza de 02/10/2026

Após revisão dos consumidores do Hidratona, foram removidos somente os assets classificados como `Sem referência encontrada` nas duas pastas autorizadas, e seus metadados adjacentes `<asset>.import`. Nenhum asset usado estava nessas pastas; as cópias usadas em `All_Character_Sprites`, `SpritesV4`, `Character_Creator/modular` e no próprio Hidratona foram preservadas. Não foi necessária migração de caminhos.

| Escopo exato dos arquivos inventariados removidos | Assets | Bytes-fonte | MiB-fonte | Metadados removidos |
|---|---:|---:|---:|---:|
| `res://sprites_andar_e_correr/` | 545 | 13.151.981 | 12,543 | 545 |
| `res://assets/New_Character_Sprites/` | 323 | 6.720.974 | 6,410 | 323 |
| **Total** | **868** | **19.872.955** | **18,952** | **868** |

Os 868 metadados somavam 632.985 bytes, contabilizados separadamente. Os caminhos absolutos foram conferidos dentro da raiz e dos dois diretórios autorizados, e cada arquivo foi removido individualmente; pastas e arquivos não inventariados foram preservados. Exclusões preexistentes da limpeza anterior não entram nestes totais. `assets/All_Character_Sprites/Boy/New_Character_Sprites/` é uma pasta distinta e não integrou esta limpeza. Saves `user://`, caches `.import/`, builds, histórico Git e presets de exportação foram preservados. A redução dos arquivos-fonte não representa economia medida no APK.

Validação: `tools/inventory_assets.py --self-check` e `--check` passaram antes e depois; inventário regenerado com 2.869 assets. As 13 referências ausentes identificadas pelo scanner permaneceram exatamente iguais ao baseline: nenhuma nova referência ausente foi introduzida. Godot confirmado como `3.3.4.stable.official.faf3f883d`; `--path . --no-window tests/test_hidratona_run.tscn` passou (código 0), verificando gêneros, tons de pele, roupas, sete frames de chuva/neve, poses, jogador, resultado e calibração. O teste usa apenas um recurso temporário de calibração em `user://`, removido ao concluir, sem gravar saves reais. Houve apenas aviso de oversampling de fonte relativo à configuração de stretch. Conferência visual interativa e exportação/APK permanecem pendentes.


## Limpeza de Sprites-v3 — 02/10/2026

Por autorização após a [revisão completa](REVISAO_SPRITES_V3.md), removidos exclusivamente os 130 PNGs da lista histórica de sem uso identificado em `res://assets/Sprites-v3/`, totalizando 129.158.228 bytes (123,175 MiB), e os 130 metadados adjacentes `<asset>.import` existentes (98.944 bytes). Cada caminho absoluto foi conferido dentro do escopo e removido individualmente; pastas não foram apagadas. Os 24 PNGs de banho usados, seus metadados e dois metadados órfãos preexistentes foram preservados. Nenhum script foi alterado.

O único carregador desta pasta resolve gênero boy/girl e frames 0–5 limpos/sujos; os removidos não correspondiam aos seus 24 caminhos, embora o scanner conservador antes os classificasse como Uso incerto. Inventário regenerado com 2.739 assets; `--self-check` e `--check` passaram antes/depois. As 13 referências ausentes permaneceram exatamente iguais ao baseline. Godot `3.3.4.stable.official.faf3f883d`: check temporário de `Load_Plataform()` confirmou as 24 texturas de banho não nulas e seus caminhos exatos, código 0; arquivo de check removido, sem gravação de saves. Apenas aviso de oversampling de fonte. Saves, caches `.import/`, builds, Git e presets preservados. Conferência visual e exportação pendentes; bytes-fonte não representam economia medida no APK.


## Limpeza de candidatos da leva de agosto — 02/10/2026

Removidos somente os 11 candidatos concretos reconferidos e os dois recursos órfãos de protótipo identificados no histórico de agosto, após autorização: 13 assets, 10.371.328 bytes (9,891 MiB), e 11 metadados adjacentes (8.478 bytes). Nenhum outro candidato genérico, recurso de uso incerto ou protótipo foi removido nesta etapa. Caminhos absolutos conferidos dentro da raiz; exclusão individual sem apagar diretórios.

Arquivos removidos:

- `res://assets/DoiAqui/sprites/actor/boy/boy-b-head-triste.png` (853183 bytes).
- `res://assets/DoiAqui/sprites/actor/boy/girl-a-head-triste.png` (1046536 bytes).
- `res://assets/DoiAqui/sprites/actor/boy/girl-b-head-triste.png` (720078 bytes).
- `res://assets/HospitalBackgroundImage/New_SalaDeEspera.png` (952510 bytes).
- `res://assets/HospitalBackgroundImage/New_SalaDentista.png` (995995 bytes).
- `res://assets/HospitalBackgroundImage/New_SalaPsicologo.png` (1025216 bytes).
- `res://src/Mini-games/Hidratona/src/level/heads/girl-a.png` (978475 bytes).
- `res://src/Mini-games/Hidratona/src/level/snow/rs_d.png` (1078630 bytes).
- `res://src/Mini-games/Hidratona/src/level/snow/rs_j.png` (1078630 bytes).
- `res://src/Mini-games/Hidratona/src/level/snow/rs_squat.png` (685397 bytes).
- `res://src/UI/Rooms/hospital_rooms/NewAssets/New_SalaPediatra.png` (955738 bytes).
- `res://data/character/parts/head_green.tres` (476 bytes).
- `res://data/character/parts/head_white.tres` (464 bytes).

As quatro imagens duplicadas do hospital tiveram SHA-256 idêntico reconfirmado antes da remoção. Mantidas as cópias consumidas em `src/UI/Rooms/hospital_rooms/NewAssets/{New_SalaPsicologo,New_SalaDentista,New_SalaDeEspera}.png` e `assets/HospitalBackgroundImage/New_SalaPediatra.png`. Os dois recursos de protótipo não tinham consumidores; `DT_Heads.tres` usa `head_boy.tres` e `head_girl.tres`. Suas texturas compartilhadas foram preservadas, sem precisar editar scripts/catálogos. Poses atuais sem cabeça e cabeças em SpritesV4 foram preservadas.

Validação: self-check inicial passou; check inicial confirmou CSV mas apontou resumo desatualizado de armazenamento/cache, regenerado nesta tarefa. Após a limpeza, inventário com 2.726 assets, `--self-check` e `--check` passaram. As mesmas 13 referências ausentes do baseline permanecem, sem novas referências quebradas. Godot 3.3.4: `tests/test_hidratona_run.tscn` e `tests/test_doi_aqui_confirm.tscn` passaram com código 0; o recurso temporário `user://doi_test_tuning.tres` foi preservado/restaurado se preexistente ou removido se criado pelo teste. Check temporário carregou/instanciou as quatro salas hospitalares e confirmou os quatro fundos preservados; passou e foi removido. Nenhum save real foi gravado. Apenas aviso de oversampling de fonte. Caches, builds, saves e presets preservados; conferência visual/exportação pendentes e bytes-fonte não medem redução no APK.
