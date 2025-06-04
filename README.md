# Instagram Encoder Framework (Hollywood Edition)

![FFmpeg](https://img.shields.io/badge/FFmpeg-H.264-green?logo=ffmpeg) ![Windows Batch](https://img.shields.io/badge/Windows-Batch-blue) ![Instagram Ready](https://img.shields.io/badge/Instagram-Ready-purple)

> **Script profissional de encoding H.264 para Instagram, com presets inspirados em Hollywood, via Batch + FFmpeg.**

---

## 📽️ Descrição

O **Instagram Encoder Framework** é um script batch avançado para Windows que converte vídeos para o formato ideal do Instagram usando o codec H.264, suportando os modos CRF (Constant Rate Factor) e Two-Pass.  
Foi criado para entregar máxima qualidade visual, compatibilidade total com as exigências do Instagram, e controle avançado de parâmetros (bitrate, resolução, áudio, GOP, etc), facilitando workflows de criadores exigentes, cineastas, influenciadores e agências.

---

## 🚀 Funcionalidades Principais

- **Qualidade Hollywood:** Codificação otimizada baseada em padrões de cinema.
- **Modos CRF e Two-Pass:** Escolha a codificação mais adequada para cada projeto.
- **Resoluções ideais para Instagram:** Inclui sugestões prontas (1080x1350, 1080x1920, 720p, etc).
- **Validação de parâmetros:** Garante que apenas configurações compatíveis são usadas.
- **Prompt interativo:** Sem necessidade de editar código; tudo guiado na execução.
- **Compatível com Reels, Feed e Stories.**
- **Log detalhado de processo.**
- **Mensagens de erro didáticas para usuário.**
- **Não depende de internet (offline).**

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
