# Documentação Técnica - AF-Game26

## 1. Visão Geral
Jogo estilo "bichinho virtual" (Tamagotchi) em Godot.
Jogador cuida das necessidades do personagem e joga mini-games.
Existem dois cenários principais (Hubs): **Casa** (`Teste.tscn`) e **Hospital** (`Hospital.tscn`).

## 2. Arquitetura de Cenários (Hubs)
Os cenários principais não têm um "mapa" fixo gigante. Eles usam `Slots` (instâncias de `RoomSlot.tscn`) onde as **Salas** são injetadas dinamicamente.

### 2.1. A Casa (`Teste.tscn`)
Salas (em `src/UI/Rooms/`):
- `Yard.tscn` (Jardim) - ID 0 ou 5
- `LivingRoom.tscn` (Sala) - ID 1
- `Kitchen.tscn` (Cozinha) - ID 2
- `Bedroom.tscn` (Quarto) - ID 3
- `Bathroom.tscn` (Banheiro) - ID 4

### 2.2. O Hospital (`Hospital.tscn`)
Salas (em `src/UI/Rooms/hospital_rooms/`):
- `WaitingRoom.tscn` (Espera) - ID 1
- `Pediatrician.tscn` (Pediatra) - ID 2
- `Dentist.tscn` (Dentista) - ID 3
- `Psychologist.tscn` (Psicólogo) - ID 4

## 3. Navegação e Minimapa
O arquivo **`src/UI/NecessityManager.tscn`** é o CanvasLayer global que controla as barras de necessidades e a navegação.
- **Barras:** Fome (Kitchen), Banheiro (Bathroom), Energia (Bedroom) e Diversão (Yard).
- **MapContainer:** Minimapa da casa (PlantaCasa.jpg) com botões (0 a 5) para ir direto para as salas.
- **HospitalMapContainer:** Minimapa do hospital com botões para ir para as salas médicas.
- **Script:** `NecessityBarsManager.gd` cuida do clique nos botões do mapa e atualiza as barras.

## 4. Estado Global e Animações
O arquivo **`AnimationController.gd`** atua como um Autoload/Singleton para gerenciar transições e estados do jogo:
- `AnimationController.status` define onde o jogador está (`MainGame`, `Hospital`, `Hidratona`, etc).
- Função `travel(from, to)` é usada para mover o personagem entre as salas do mapa.
- Controla `is_travelling` para bloquear cliques repetidos durante animações.

## 5. Mini-Games
Ficam na pasta `src/Mini-games/`:
- **DoiAqui**: Mini-game sobre dor (abre na Sala de Espera ou eventos).
- **Hidratona**: Mini-game de beber água.
- **Match-3**: Mini-game de combinar peças.
- **PlantCare**: Mini-game no Jardim.
- **AlongamentoTest**: Jogo de alongamento (adicionado mais recentemente).

## 6. Sons
Efeitos sonoros e músicas divididos em:
- `assets/sounds/sons editados/`
- `assets/sounds/Sons Atualizados/`
Tocados por nodes `AudioStreamPlayer` e chamados via código (ex: `_on_Button_pressed()`).
