# Instagram Encoder Framework (Hollywood Edition)

![FFmpeg](https://img.shields.io/badge/FFmpeg-H.264-green?logo=ffmpeg) ![Windows Batch](https://img.shields.io/badge/Windows-Batch-blue) ![Instagram Ready](https://img.shields.io/badge/Instagram-Ready-purple)

> **Script profissional de encoding H.264 para Instagram, com presets inspirados em Hollywood, via Batch + FFmpeg.**

---

## 📽️ Descrição

O **Instagram Encoder Framework** é um script batch avançado para Windows que converte vídeos para o formato ideal do Instagram usando o codec H.264, suportando os modos CRF (Constant Rate Factor) e Two-Pass.  
Foi criado para entregar máxima qualidade visual, compatibilidade total com as exigências do Instagram, e controle avançado de parâmetros (bitrate, resolução, áudio, GOP, etc), facilitando workflows de criadores exigentes, cineastas, influenciadores e agências.

---

## 🚀 Funcionalidades Principais

- **Entrada guiada por prompts**: fácil de usar, sem necessidade de editar o script.
- **Qualidade Hollywood**: presets e flags otimizados, com controle manual ou automático de parâmetros.
- **Modo CRF ou Two-Pass**: escolha a codificação que mais se adapta ao seu objetivo.
- **Validação robusta de entradas**: evita erros comuns e garante máxima compatibilidade.
- **Compatibilidade máxima com Instagram**: vídeo final sempre pronto para upload, sem surpresas.
- **Totalmente offline**: não depende de conexão com internet.

---

## 🖥️ Requisitos

- **Windows 10 ou superior**
- **FFmpeg instalado e no PATH**  
  [Baixe aqui](https://ffmpeg.org/download.html)

---
## 🛠️ Parâmetros Técnicos & Presets
CRF recomendado: 17–22
Modos suportados: 30fps
CRF: equilíbrio entre qualidade e tamanho
Two-Pass: controle exato de bitrate e tamanho final
Resoluções padrão Instagram:
1080x1920 (Stories/Reels)
1920x1080 (Horizontal)
Audio: AAC, 128kbps
GOP (keyint): Ajustado para melhor playback nas redes
Preset FFmpeg: slow/medium (ajustável no script)
Flags extras: Compatibilidade máxima garantida

## 📦 Instalação

1. **Clone ou baixe o repositório:**
   ```sh
   git clone https://github.com/gabrielschoenardie/encoder.git
