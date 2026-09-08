# AF-Game26 - Documentação do Projeto

## Visão Geral
Este é um projeto desenvolvido em Godot focado em simulação de vida e mecânicas de "necessidades" (estilo Tamagotchi/The Sims) integradas com mini-games.

## Estrutura de Pastas Principal
- `src/`: Contém todos os scripts de lógica e cenas principais.
- `assets/`: Recursos visuais (sprites), sonoros e fontes.

## Sistemas Principais

### 1. Gerenciamento de Personagem (`CharacterController.gd`)
Controla a personalização visual do jogador:
- **Atributos**: Gênero (boy/girl), cabelo, cor de pele, roupas.
- **Funcionalidade**: Carrega dinamicamente os sprites baseados na customização para diferentes partes do jogo (Plataforma, Match-3, Hidratona).

### 2. Sistema de Necessidades (`NecessityBars.gd`)
Gerencia o estado interno do jogador através de barras que decaem com o tempo:
- **Necessidades**:
  - `Higiene` (Banho)
  - `Bexiga` (Uso do banheiro)
  - `Fome` (Alimentação)
  - `Energia` (Sono)
  - `Diversão` (Brincadeiras)
- **Mecânica de Dor**: Existe um sistema aleatório (`random_pain`) que pode gerar estados de mal-estar (dor de cabeça, febre, dor no braço), pausando o jogo para interação.

### 3. Navegação e UI (`NecessityBarsManager.gd` & `AnimationController.gd`)
- **Salas Disponíveis**:
  0. Quintal (Yard)
  1. Sala de Estar (LivingRoom)
  2. Cozinha (Kitchen)
  3. Quarto (Bedroom)
  4. Banheiro (Bathroom)
- **Navegação**: O `AnimationController` lida com as transições de "viagem" entre as salas.

### 4. Mini-games
O projeto inclui vários mini-games para satisfazer as necessidades ou por gameplay pura:
- **Match-3**: Jogo de combinar 3.
- **Hidratona**: Provavelmente um runner ou jogo focado em hidratação/corrida.
- **DoiAqui**: Relacionado ao tratamento das dores aleatórias.
- **Escovar**: Mini-game de higiene bucal.

## Fluxo de Jogo
1. **Inicialização**: Carrega os dados do personagem e necessidades salvas.
2. **Loop**: As necessidades decrescem; o jogador deve navegar entre as salas para interagir com objetos (cama, pia, geladeira) ou jogar mini-games para restaurar as barras.
3. **Eventos**: Dores aleatórias podem surgir, exigindo atenção do jogador.

## Persistência
O sistema de salvamento está implementado via `SaveController.gd`, utilizando o método `save()` presente nos controladores principais (`CharacterController`, `NecessityBars`) para armazenar o estado atual.
