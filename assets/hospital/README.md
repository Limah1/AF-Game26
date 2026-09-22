# Áudios e diálogos do Hospital

Cada profissional mantém seu JSON de falas nesta pasta. As dublagens ficam
centralizadas em `src/Assets/Audio/Voice/Hospital`:

```text
assets/hospital/
├── dentista/
│   └── dialogo.json
├── pediatra/
│   └── dialogo.json
├── psicologo/
│   └── dialogo.json
└── enfermeira/
    └── dialogo.json
```

Os caminhos dos JSONs são definidos nas cenas de cada sala e cada campo
`voice` aponta para a dublagem centralizada.
