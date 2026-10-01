# Verificação das correções Android

Executar na raiz do projeto com Godot **3.3.4**. Os testes não gravam o save do jogador nem as configurações de áudio.

```powershell
$godot = 'D:/GODOT/Godot_v3.3.4-stable_win64.exe'
& $godot --no-window --path . tests/test_android_regressions.tscn
& $godot --no-window --path . tests/test_hidratona_run.tscn
$env:MATCH3_SOAK_SECONDS = '1800'
& $godot --no-window --path . tests/test_match3_soak.tscn
```

`ANDROID_CAPTURE` define uma pasta opcional de screenshots. O teste de carga usa 20 segundos quando `MATCH3_SOAK_SECONDS` não está definido. Cada linha `MATCH3_METRICS` registra nós, objetos, memória, frutas, mediana do tempo de quadro e processamento de física. O teste repete destruição/reposição de frutas e, depois, exercita troca inválida, troca válida e cascata real.

## Resultados locais

- Regressões: alinhamento hospital/casa para menino/menina, cabelos A/B e roupas R1/R2; pescoço nos três tabuleiros e nos resultados; conclusão e cancelamento dos três minigames do banheiro; retorno interrompido; mapa; restrições de espuma/vaso; loading; botão da flor; voz interrompida e reprodução única sem alterar streams compartilhados.
- Hidratona: verificação dos assets, poses e calibração existente; tom nos dois frames de pulo, nos três climas e em três tons de pele; tom do rig no tutorial. As luvas da neve continuam com sua cor de roupa.
- Carga local de **120 segundos / 104 ciclos**: 649 nós, 1.770 objetos e 36 frutas ao fim dos ciclos. Memória estabilizou perto de 43,32 MB; mediana de quadro de 13,33 ms na máquina de teste. Não houve crescimento contínuo. Isso não confirma o desempenho prolongado no Android.
- O Godot 3.3.4 emite avisos de recursos na saída também no teste de carga anterior às correções. O tutorial da Hidratona possui um erro preexistente na trilha `tutorial-dedo:position`, separado da verificação de pele.

## Ainda validar no aparelho

Instalar um APK com estas alterações; tocar na flor; continuar um save válido e experimentar um save inválido/ausente; repetir conclusão/saída dos três minigames do banheiro e usar mapa/setas/pia depois de cada retorno. Avançar, reiniciar e fechar diálogos enquanto a voz toca. Conferir personagem e pulos com os tons disponíveis.

Jogar Match-3 continuamente por **30 minutos**, repetindo fases. Anotar aparelho, versão do APK, FPS/tempo de quadro e memória antes/depois. Confirmar que o toque continua respondendo e que não há queda progressiva de desempenho. Essa sessão Android não foi executada nesta máquina.
