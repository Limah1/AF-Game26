# Tutorial: Como Editar Estados e Esconder Peças no CharacterRig

Este documento ensina como você pode criar novas poses (estados) para o personagem, esconder as partes do corpo que não quer mostrar e ajustar as posições no sistema modular (`CharacterRig.gd`).

---

## 1. Como Criar um Novo Estado (Exemplo: "Pulo")

Sempre que quiser adicionar uma pose nova, siga estes dois passos:

1. Abra o arquivo `CharacterRig.gd`.
2. Logo no topo (linha 3), adicione o nome do novo estado na variável `export`:
```gdscript
export(int, "Idle", "Walk", "Run", "Sleep", "Toilet", "Pulo") var state = 0 setget set_state
```
Neste exemplo, "Pulo" virou o estado número **5** (começa do zero).

---

## 2. Como Esconder Elementos

Vá até a função `_apply_state_setup()`. É nela que você diz ao jogo quais partes do corpo ficam visíveis para cada estado.

Para o novo estado que criamos (`elif state == 5:`), você tem três formas de gerenciar o que aparece:

### Método A: Mostrar TUDO e esconder apenas um específico
Use `show_all()` no começo e depois oculte o que não quer com `.visible = false`.
```gdscript
	elif state == 5: # Pulo
		show_all() # Liga todas as partes
		rig_pants.visible = false # Esconde a calça
		rig_hair.visible = false # Esconde o cabelo
```

### Método B: Esconder TUDO e mostrar apenas específicos (Mais fácil)
Use a função `show_parts()`, passando uma lista com os nomes exatos dos nós que você quer manter na tela.
```gdscript
	elif state == 5: # Pulo
		# Tudo é escondido, menos a Cabeça, Torso e Braços
		show_parts(["Head", "Torso", "LeftArm", "RightArm"])
```

### Método C: Esconder TUDO
Se quiser fazer o personagem sumir completamente (ex: cena de transição):
```gdscript
	elif state == 6: # Invisível
		hide_all()
```

---

## 3. Como Mover e Girar Peças (Fazer a Pose)

Ainda dentro do `_apply_state_setup()`, após ligar/desligar as peças, você ajusta a posição delas. 

### Posição (X, Y)
Você pode descobrir os números exatos movendo a peça manualmente no editor visual do Godot (na cena `.tscn`) e olhando a aba **Inspector** à direita. Depois, copie os números para cá:
```gdscript
		# Move o braço esquerdo para cima
		rig_left_arm.position = Vector2(-40, -50)
```

### Rotação
Use a propriedade `rotation_degrees` para girar a peça (números positivos giram para direita, negativos para esquerda).
```gdscript
		# Gira o braço para parecer que está acenando
		rig_left_arm.rotation_degrees = -90 
```

---

## 4. Como Fazer Animação Contínua (Ex: Respirar ou Andar)

Se o estado for estático (como o de Dormir), o passo 3 já basta.
Mas se você quiser que as peças fiquem balançando enquanto a cena roda, vá para o final do script, na função `_process(delta)`.

Lá, adicione um novo `if` para o seu estado e use Matemática (Seno) para criar um movimento contínuo baseado no relógio do jogo (`time`).

**Exemplo: Fazer a cabeça flutuar para cima e para baixo:**
```gdscript
	if state == 5: # Pulo
		# Cria um valor que sobe e desce entre -10 e +10
		var flutuacao = sin(time * 3.0) * 10.0
		
		# Aplica esse valor no eixo Y da cabeça
		rig_head.position.y = flutuacao
		return # <-- Muito importante o return para ele não misturar com animações abaixo
```

### Resumo:
1. **Adiciona** no `export`.
2. **Esconde/Mostra** peças no `_apply_state_setup()`.
3. **Muda Posições fixas** no `_apply_state_setup()`.
4. (Opcional) **Faz Balançar** no `_process(delta)`.

---

## 5. E se eu quiser uma animação complexa (Keyframes)?

O método 4 (usar matemática no código) é ótimo para coisas simples (respirar, braço balançar). Mas se você quiser uma animação de "Ataque" com espada ou "Cair", usar matemática é muito difícil.

Para animações complexas, você deve usar o sistema tradicional do Godot:

1. Abra o `CharacterRig.tscn`.
2. Adicione um nó **`AnimationPlayer`** (Filho do CharacterRig).
3. Crie uma Nova Animação (Ex: "Andar_Frente").
4. Na linha do tempo (Timeline) embaixo, adicione chaves (Keyframes) na propriedade `Position` e `Rotation` de cada pedaço do corpo no tempo exato que você quer (como num vídeo).
5. Depois, no `CharacterRig.gd`, em vez de fazer contas matemáticas, você só roda o comando:
```gdscript
$AnimationPlayer.play("Andar_Frente")
```

Isso tira a responsabilidade da animação do código e joga para a interface visual poderosa do Godot! Você usa código só para carregar a textura, e usa a Timeline para animar.
