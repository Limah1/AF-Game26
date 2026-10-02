# Agentes por cena — AF-Game26

## Como usar

O usuário pode indicar o nome ou caminho de qualquer cena `.tscn` e descrever
a alteração. Exemplos:

- `Use um agente na cena Bedroom.tscn para corrigir a troca de roupa.`
- `Cena res://src/Mini-games/Hidratona/src/level/Level.tscn: ajuste o salto.`
- `Use agentes separados para Bathroom.tscn e Kitchen.tscn.`
- `Use o agente Limpeza de assets para revisar os arquivos não utilizados.`

Este arquivo define instruções e áreas de trabalho; não cria processos permanentes.
Quando o usuário pedir um agente para uma cena ou limpeza de assets, delegue a tarefa a um
subagente, se a ferramenta estiver disponível. Caso contrário, execute o mesmo
fluxo diretamente e informe essa limitação. Não crie chats novos automaticamente.

## Fluxo do agente de cena

1. Resolva o caminho com `rg --files -g '*.tscn'`. Se houver nomes repetidos,
   use o contexto do pedido; pergunte somente se ainda houver ambiguidade.
2. Leia a cena, os scripts ligados a ela, as cenas instanciadas e os recursos
   relevantes. Confira os autoloads em `project.godot` e procure os chamadores
   antes de alterar funções compartilhadas.
3. Informe a cena escolhida e implemente a alteração solicitada com o menor
   diff que resolve a causa. Reutilize os padrões e recursos existentes.
4. Valide com o teste existente relacionado. Para lógica nova não trivial,
   acrescente um pequeno teste de regressão seguindo o padrão de `tests/`.
5. Entregue os arquivos alterados, o resultado da validação e qualquer
   comportamento que ainda precise ser conferido no editor.

## Áreas de trabalho

Os nomes abaixo são papéis para delegação. Qualquer outra cena também pode ser
selecionada pelo caminho, sem precisar cadastrar um agente novo.

| Papel | Cenas e scripts principais |
| --- | --- |
| Casa | `src/UI/Rooms/`: Bedroom, Bathroom, Kitchen, LivingRoom, Yard e Jardim; `src/UI/HouseRoom.gd` |
| Hospital | `src/Hospital.tscn`, `src/Hospital.gd`, `src/UI/Rooms/hospital_rooms/` |
| Personagem | `src/UI/Character_Creator.tscn`, seletores em `src/UI/`, `src/CharacterData/`, `src/Mini-games/CharacterTest/` |
| Hidratona | `src/Mini-games/Hidratona/` |
| Match-3 | `src/Mini-games/Match-3/` |
| DoiAqui | `src/Mini-games/DoiAqui/` |
| PlantCare | `src/Mini-games/PlantCare/` |
| Respiração | `src/Mini-games/Respiracao/` |
| Higiene | `src/UI/Minigame_bath/`, `src/UI/Minigame_escovar/`, `src/UI/Minigame_lavar_maos/` |
| Navegação e áudio | `src/Landing_Page_Temp.tscn`, `src/MainScreen.tscn`, `src/UI/Loading.tscn`, `src/Audio/` |
| Limpeza de assets | `docs/tecnico/MAPA_ASSETS_E_SAVE.md`, `docs/tecnico/inventario_assets.csv`, `tools/inventory_assets.py` e os assets do escopo solicitado |

## Agente Limpeza de assets

Objetivo: reduzir o tamanho do projeto removendo apenas assets comprovadamente
dispensáveis dentro do escopo autorizado pelo usuário.

1. Leia `docs/tecnico/MAPA_ASSETS_E_SAVE.md`, inclusive os limites do scanner
   e o histórico de limpeza. Confira `git status` para separar exclusões
   preexistentes das mudanças desta tarefa.
2. Reutilize `tools/inventory_assets.py` (Python 3.10+, biblioteca padrão).
   Execute `python tools/inventory_assets.py --self-check` e
   `python tools/inventory_assets.py --check`. Se o inventário estiver
   desatualizado, execute `python tools/inventory_assets.py` e confira o diff.
3. Prepare uma lista concreta com caminhos, classificação, tamanho e evidências
   de ausência de uso. Priorize economia de espaço, mas não trate
   `Sem referência encontrada` como prova nem `Uso incerto` como descartável.
   Revise também referências de testes, protótipos e projetos aninhados.
4. Rastreie referências em cenas, scripts, recursos, JSONs, catálogos e
   carregamentos dinâmicos. Proteja variações e fallbacks do personagem,
   banho/sono, frames de Hidratona, estágios de plantas e vozes do hospital.
   Duplicatas idênticas só permitem remoção após conferir e atualizar seus
   consumidores; nomes antigos não comprovam desuso.
5. Pedidos de revisão entregam a lista sem excluir arquivos. Pedidos de limpeza
   autorizam remover os candidatos comprovados dentro do escopo pedido;
   mantenha os incertos e explique a evidência faltante. A lista histórica
   de 25 remoções não autoriza excluir novos candidatos automaticamente.
6. Antes de remover, confira os caminhos absolutos dentro da raiz do projeto.
   Remova os metadados adjacentes `<asset>.import` dos assets excluídos.
   Preserve saves `user://`, caches `.import/`, histórico Git, builds e presets
   de exportação, salvo pedido específico para essas áreas.
7. Depois da limpeza, regenere o inventário e execute `--self-check` e `--check`.
   Compare referências ausentes antes/depois e corrija as introduzidas pela
   tarefa. Valide os fluxos afetados no Godot 3 e a exportação quando disponível;
   proteja saves reais ao escolher testes. Informe validações pendentes.
8. Registre no mapa os arquivos removidos, a redução dos arquivos-fonte e a
   validação feita. Não apresente essa redução como economia medida no APK;
   isso exige comparar exportações equivalentes.

O coordenador evita limpeza em paralelo com agentes que editam ou adicionam
assets nas mesmas áreas e assume eventuais mudanças em scripts compartilhados.

## Coordenação

- Cada subagente recebe a cena exata, o objetivo, os arquivos que pode editar
  e as instruções deste arquivo. Ele deve ler as dependências antes de editar.
- Para cenas independentes, use um subagente por tarefa, respeitando o limite
  disponível. Não deixe dois agentes editarem o mesmo arquivo simultaneamente.
- O coordenador assume alterações compartilhadas em autoloads, personagem,
  save e navegação, ou atribui esses arquivos exclusivamente a um agente.
  O agente de cena comunica a necessidade antes de sair do escopo atribuído.
- O coordenador revisa os diffs e valida a integração antes de concluir.

## Regras do projeto

- O projeto usa formato e sintaxe de Godot 3 (`config_version=4`, cenas
  `format=2`, `export`, `onready`, `KinematicBody2D`). Não migre para Godot 4.
- Preserve nomes de nós, NodePaths, sinais, IDs de recursos e caminhos
  `res://`, salvo quando a alteração solicitada exigir atualizá-los.
- Confira `git status` antes de editar. Preserve mudanças e exclusões
  preexistentes do usuário; não restaure assets ausentes automaticamente.
- Não edite caches `.import/`, builds ou arquivos gerados para corrigir código.
- Use `docs/tecnico/README_Project.md` para contexto geral e os testes
  relacionados em `tests/`. Consulte documentação específica quando necessário.
- Use um executável Godot 3 disponível e confirme sua versão antes dos testes.
  Para testes que estendem `SceneTree`, use:
  `& '<executável Godot 3>' --path . --no-window -s tests/<teste>.gd`.
  Para testes `.tscn`, use:
  `& '<executável Godot 3>' --path . --no-window tests/<teste>.tscn`.
  Se não for possível executar, informe que a validação ficou pendente.
- Não adicione dependências, abstrações ou refatorações fora do pedido.
- Responda em português, com explicação curta e resultado concreto.
