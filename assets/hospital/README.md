# Áudios e diálogos do Hospital

Cada profissional possui uma pasta própria com o JSON de falas e a pasta de
áudio correspondente:

```text
assets/hospital/
├── dentista/
│   ├── dialogo.json
│   └── audio/
├── pediatra/
│   ├── dialogo.json
│   └── audio/
├── psicologo/
│   ├── dialogo.json
│   └── audio/
└── enfermeira/
    ├── dialogo.json
    └── audio/
```

Os caminhos dos JSONs são definidos explicitamente nas cenas de cada sala.
Os áudios serão vinculados às falas na próxima etapa, quando o botão de voz
for adicionado ao painel.
