# Roteiro de teste completo — AF-Game26

Checklist manual para a versão jogável no **PC (Windows)** e no **Android**. Execute os casos pela interface do jogo, na ordem abaixo: primeiro uma partida nova no PC, depois a retomada; repita no Android. Clique e arraste no PC correspondem a toque e gesto no Android. Este documento registra o teste; nenhum caso está aprovado antes da execução.

## Preparação e registro

1. Anote a versão/commit, a versão do Godot ou do APK, o aparelho Android, a resolução e o nome do testador. Abra o projeto pela cena principal (`F5` no Godot) no PC e instale a exportação Android da mesma versão.
2. Use um **usuário Windows de teste** e um **dispositivo ou usuário Android de teste** para isolar `user://`. Não limpe os dados da instalação pessoal. Confirme que o perfil de teste começa sem progresso; depois mantenha os dados entre a sessão nova e a sessão de retomada. O progresso geral fica em `user://savegame.save` e o jardim em `user://plant_care.save`.
3. Execute todos os casos no PC; recomece a lista no Android. Anote o valor/estado das necessidades antes e depois das ações que devem mudá-las. Preserve capturas, vídeo curto ou log do depurador para falhas.
4. Em cada linha, preencha `PC` e `Android` com **PASSOU**, **FALHOU**, **BLOQUEADO** ou **NÃO EXECUTADO**, seguidos do que ocorreu. `BLOQUEADO` significa que um bug anterior impediu o passo; cite seu ID. Não marque uma cena aberta isoladamente no editor como aprovação da navegação pelo jogo.

**Execução:** versão/commit: ______ · APK: ______ · PC/resolução: ______ · Android/modelo/versão/resolução: ______ · testador: ______ · data: ______

**Formato de bug:** ID do caso; plataforma e versão; estado anterior (sala, personagem, necessidades e save); passos exatos; esperado; observado; frequência (`x/y` tentativas); captura/vídeo; erro do depurador/log, se houver. Registre também se o bug se repete depois de reiniciar o jogo.

## 1. Início, personagem e estado geral

| ID | Passos | Resultado esperado | PC: observado/status | Android: observado/status | Evidência | Bug |
| --- | --- | --- | --- | --- | --- | --- |
| IN-01 | Inicie sem save no perfil de teste; tente **Continuar**. | Continuar indisponível; menu responde e não abre partida inexistente. | ______ | ______ | ______ | ______ |
| IN-02 | Escolha **Novo jogo/Recomeçar**; selecione gênero, tom de pele e cabelo; confirme. | As opções escolhidas aparecem na prévia e a seleção avança para roupas. | ______ | ______ | ______ | ______ |
| IN-03 | Selecione roupa e cores de cima/baixo; confirme e aguarde carregar. | A casa abre com o personagem na aparência escolhida, sem partes ausentes ou sobrepostas. | ______ | ______ | ______ | ______ |
| IN-04 | Abra o mapa; visite todas as salas pelo mapa e depois pelas setas esquerda/direita, incluindo a passagem entre as extremidades. | Cada comando chega à sala indicada uma vez; setas, mapa e personagem voltam a responder após a transição. | ______ | ______ | ______ | ______ |
| IN-05 | Abra e feche o mapa em duas salas; tente tocar/clicar uma sala já selecionada e navegar durante uma transição. | O mapa fecha sem prender controles; comandos durante a transição não criam salas duplicadas nem travam a navegação. | ______ | ______ | ______ | ______ |
| IN-06 | Observe as barras; faça uma ação de fome, higiene, energia e diversão nos casos abaixo; compare antes/depois. | As barras visíveis refletem as ações correspondentes e continuam atualizando sem valores inválidos. | ______ | ______ | ______ | ______ |
| IN-07 | Abra pausa, continue, pause de novo e volte ao menu. | Pausa interrompe a partida; continuar restaura os controles; voltar ao menu deixa o jogo utilizável. | ______ | ______ | ______ | ______ |
| IN-08 | Ajuste os controles de áudio disponíveis; ouça música, efeito e voz/diálogo; feche e reabra a tela de áudio. | Cada controle altera seu som correspondente e o ajuste exibido permanece ao reabrir. | ______ | ______ | ______ | ______ |
| IN-09 | Feche normalmente após criar o personagem; abra de novo e use **Continuar**. | Personagem, aparência e necessidades salvas reaparecem; a partida abre sem duplicações ou cena incorreta. | ______ | ______ | ______ | ______ |
| IN-10 | No Android, coloque o app em segundo plano e retorne; depois use o botão Voltar do sistema e reabra. No PC, retire o foco da janela e retorne. | O jogo continua ou salva/restaura de modo consistente; não perde o progresso nem fica em pausa invisível. | ______ | ______ | ______ | ______ |

## 2. Casa e minijogos

| ID | Passos | Resultado esperado | PC: observado/status | Android: observado/status | Evidência | Bug |
| --- | --- | --- | --- | --- | --- | --- |
| CA-01 | Na sala, acione a TV duas vezes. | A TV alterna entre ligada e desligada a cada ação. | ______ | ______ | ______ | ______ |
| CA-02 | Na sala, abra e feche o painel dos pais/Dói Aqui; abra e feche o painel de yoga. | Cada painel aparece e fecha sem bloquear os demais botões. | ______ | ______ | ______ | ______ |
| CA-03 | Pelo painel de yoga, inicie **Alongamento**; conclua as cinco rodadas e volte à casa. | As escolhas avançam pelas rodadas; a tela final aparece e o retorno deixa a casa navegável. | ______ | ______ | ______ | ______ |
| CA-04 | Pelo painel Dói Aqui, abra o tutorial/indicador, interaja e volte; depois inicie e conclua uma partida. | Tutorial e jogo abrem pelas opções corretas; a conclusão mostra o resultado e permite voltar à casa. Se faltar um estado de dor, registre a pré-condição. | ______ | ______ | ______ | ______ |
| CO-01 | Na cozinha, toque/click na geladeira e feche o painel sem jogar; abra novamente. | Geladeira e painel abrem/fecham corretamente e continuam acionáveis. | ______ | ______ | ______ | ______ |
| CO-02 | Pela geladeira, entre no tutorial **Match-3**, complete-o e retorne. | O tabuleiro tutorial responde aos movimentos, conclui e oferece retorno sem prender a cozinha. | ______ | ______ | ______ | ______ |
| CO-03 | Pela geladeira, inicie **Match-3** normal, complete uma partida e retorne. | Jogo e resultado abrem; voltar restaura a casa/cozinha e o estado de fome condiz com a partida. | ______ | ______ | ______ | ______ |
| QU-01 | No quarto, durma, observe o estado de sono e acorde pelo botão exibido. | Cena, personagem e controles mudam para dormir e retornam ao acordar; energia reflete o descanso. | ______ | ______ | ______ | ______ |
| QU-02 | Abra a personalização/guarda-roupa, escolha outra opção e confirme; saia e volte ao quarto. | A escolha aparece no personagem e permanece após mudar de sala. | ______ | ______ | ______ | ______ |
| QU-03 | Acione guarda-chuva e casaco quando os botões estiverem disponíveis; saia e volte. | O acessório escolhido aparece de modo consistente no personagem, sem duplicação ou perda visual. | ______ | ______ | ______ | ______ |
| QU-04 | Abra a introdução de **Respiração**, volte; abra de novo, inicie, conclua o exercício e saia. | Voltar da introdução libera o botão; o exercício responde ao pressionar/soltar e retorna ao quarto com controles ativos. | ______ | ______ | ______ | ______ |
| BA-01 | No banheiro, entre em **Banho**, execute as ações até concluir e volte. | O minijogo abre, termina e devolve personagem, navegação e higiene sem controles bloqueados. | ______ | ______ | ______ | ______ |
| BA-02 | Use o vaso, complete a ação do papel higiênico e observe a pia. | A sequência termina e a pia passa a oferecer **Lavar as Mãos**; o estado do banheiro é atualizado. | ______ | ______ | ______ | ______ |
| BA-03 | Pela pia após o vaso, conclua **Lavar as Mãos** e volte ao banheiro. | Água, sabão e gestos respondem; concluir libera personagem, pia e navegação. | ______ | ______ | ______ | ______ |
| BA-04 | Com a pia fora da sequência de lavar as mãos, entre em **Escovar os Dentes**, conclua e volte. | Escova e progresso respondem; concluir fecha o minijogo e libera a pia para uso posterior. | ______ | ______ | ______ | ______ |
| QI-01 | No quintal, abra o portão/painel e feche sem iniciar um jogo. | O painel fecha, o portão volta ao estado anterior e o quintal permanece navegável. | ______ | ______ | ______ | ______ |
| QI-02 | Pelo painel do quintal, inicie o tutorial **Hidratona**, conclua a sequência e volte. | Tutorial recebe movimentos/gestos e oferece caminho de volta ao quintal. | ______ | ______ | ______ | ______ |
| QI-03 | Inicie **Hidratona** normal, jogue até a tela de resultado e volte à casa. | Comandos, obstáculos e resultado funcionam; voltar restaura quintal e estado de diversão/hidratação correspondente. | ______ | ______ | ______ | ______ |

## 3. Jardim e Plant Care — prioridade

Execute JD-01 a JD-04 como um único caminho pelo jogo. Se uma etapa falhar, registre o ponto exato e marque as etapas dependentes **BLOQUEADO**. Abrir `PlantCareMenu.tscn` diretamente serve apenas como diagnóstico adicional, não substitui a aprovação desse caminho.

| ID | Passos | Resultado esperado | PC: observado/status | Android: observado/status | Evidência | Bug |
| --- | --- | --- | --- | --- | --- | --- |
| JD-01 | No quintal, toque/click na planta visível uma vez; repita após aguardar alguns segundos. | A interação indicada ao jogador deve abrir o Jardim/Plant Care ou mostrar claramente como entrar; não pode parecer um botão inerte. Registre se nada acontece. | ______ | ______ | ______ | ______ |
| JD-02 | Tente alcançar a cena **Jardim** pelas setas e pelo mapa; registre a sequência exata de salas. | O Jardim é alcançável por um controle apresentado ao jogador; o botão **Começar** aparece e responde. | ______ | ______ | ______ | ______ |
| JD-03 | No Jardim, acione **Começar**. No Plant Care, arraste uma planta da lista para um dos dois espaços livres e mantenha-a ali por 1,5 s; regue até avançar um estágio. | Plant Care abre; a planta é colocada, o saldo muda pelo custo e a rega produz progresso visual e novo estágio. | ______ | ______ | ______ | ______ |
| JD-04 | Use **Voltar** para a casa; reabra Plant Care pelo mesmo caminho. | Casa e navegação voltam; planta, estágio, moedas e espaços desbloqueados continuam como antes de sair. | ______ | ______ | ______ | ______ |
| JD-05 | No Plant Care, toque um espaço fechado, confirme a compra se houver saldo, saia e reabra. | O diálogo mostra o custo; confirmar desconta moedas uma vez e mantém o espaço desbloqueado após reabrir. | ______ | ______ | ______ | ______ |

**Hipótese a verificar:** a planta exibida no quintal está declarada como `Sprite` em `Yard.tscn`, sem sinal de clique conectado. Há outra cena, `Jardim.tscn`, com botão **Começar** ligado ao Plant Care. O teste automatizado atual de Plant Care abre o menu diretamente; ele não comprova a entrada pelo quintal.

## 4. Hospital, dor e retorno

| ID | Passos | Resultado esperado | PC: observado/status | Android: observado/status | Evidência | Bug |
| --- | --- | --- | --- | --- | --- | --- |
| HO-01 | Pelo portão/painel do quintal, escolha **Hospital**. | Hospital abre pela interface do jogo, com mapa e personagem utilizáveis. | ______ | ______ | ______ | ______ |
| HO-02 | Visite recepção/sala de espera, pediatra, dentista e psicólogo pelo mapa e pelas setas. | A sala solicitada abre; transições e passagem da última para a primeira não travam. | ______ | ______ | ______ | ______ |
| HO-03 | Em cada sala, abra o diálogo/interação disponível e feche ou complete as escolhas apresentadas. | Diálogo responde a escolhas, texto/voz quando disponíveis e permite voltar aos controles da sala. | ______ | ______ | ______ | ______ |
| HO-04 | Nas salas que apresentam TV, acione-a duas vezes. Em cada sala, abra e feche o painel de dor. | TV alterna; painel abre/fecha sem sobreposição permanente ou perda de interação. | ______ | ______ | ______ | ______ |
| HO-05 | Inicie **Dói Aqui** pelo painel de uma sala do hospital, conclua uma partida e volte. | Minijogo e resultado aparecem; retorno leva a uma tela de casa/hospital navegável e o estado de dor é atualizado. | ______ | ______ | ______ | ______ |
| HO-06 | Use o botão do mapa do hospital para voltar à casa; depois abra o hospital novamente. | Retorno chega à casa sem personagem/controles presos; a entrada no hospital continua possível. | ______ | ______ | ______ | ______ |

## Encerramento

Ao terminar cada plataforma, conte **passou / falhou / bloqueado / não executado** e liste os bugs por ID, começando pelos que impedem acesso a outras áreas. Compare PC e Android, sobretudo tamanho/posição de botões, toque e arraste, áudio e retomada. Um caso só passa quando os passos foram executados pelo caminho indicado e o resultado esperado foi observado. Não apague o perfil de teste até concluir a análise das falhas.
