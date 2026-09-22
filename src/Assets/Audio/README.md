# Audio

- `Music`: trilhas e músicas contínuas.
- `SFX`: interface, ambiente e ações, separados por área ou minigame.
- `Voice`: dublagens, separadas por sistema e personagem.

Novos arquivos devem usar nomes curtos em `snake_case`, sem espaços ou acentos. Todo `AudioStreamPlayer` deve declarar explicitamente um dos buses `Music`, `SFX` ou `Voice`.
