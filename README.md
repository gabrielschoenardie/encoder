# 📱 Instagram Encoder Framework V5
## Professional Zero-Recompression Video Encoder for Instagram

![Version](https://img.shields.io/badge/version-5.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Quality](https://img.shields.io/badge/quality-Hollywood%20Level-gold.svg)
![Instagram](https://img.shields.io/badge/Instagram-Zero%20Recompression-ff69b4.svg)

> **🎬 Professional-grade video encoder that produces Hollywood-level quality videos optimized for Instagram with guaranteed zero recompression.**

---

## 🎯 **Overview**

The Instagram Encoder Framework V5 is a cutting-edge batch script that transforms your videos into Instagram-ready content without quality loss. Built with the same encoding principles used by Netflix, Disney+, and HBO Max, but specifically optimized for Instagram's requirements.

### **🏆 Key Features**

- **🎬 Hollywood-Level Quality** - Professional broadcast-grade encoding parameters
- **📱 Zero-Recompression Guarantee** - Instagram accepts videos without re-processing
- **🛡️ Enterprise-Grade Reliability** - Advanced error handling and auto-recovery
- **🧠 Intelligent Detection** - Auto-detects hardware, formats
- **📊 Professional Profiles** - Reels, Stories, Feed, IGTV, Cinema presets
- **🔍 Advanced Parsing** - Robust video analysis and validation
- **💾 Backup & Recovery** - Automatic backup system with rollback capability

---

## 🎮 **Technical Specifications**

### **Encoding Standards**
- **Video Codec:** H.264 (libx264) with Hollywood-level parameters
- **Audio Codec:** AAC LC 48kHz Stereo (up to 320kbps)
- **Container:** MP4 with faststart optimization
- **Color Space:** BT.709 TV Range (Instagram native)
- **Pixel Format:** yuv420p (universal compatibility)

### **Supported Resolutions**
- **📱 Reels/Stories (9:16):** 1080x1920 @ 30fps
- **🔲 Feed Square (1:1):** 1080x1080 @ 30fps  
- **📺 Feed/IGTV (16:9):** 1920x1080 @ 30fps
- **🎬 Cinema (21:9):** 2560x1080 @ 30fps
- **⚙️ Custom:** User-defined resolutions

---
## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Uso Básico](#-uso-básico)
- [Configurações Avançadas](#-configurações-avançadas)
- [Parâmetros Técnicos](#-parâmetros-técnicos)
- [Resolução de Problemas](#-resolução-de-problemas)
- [Exemplos](#-exemplos)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

## 🎯 Visão Geral

O **Instagram Encoder Framework** é um script batch para Windows que automatiza a codificação de vídeos com parâmetros profissionais otimizados para as plataformas do Instagram (Reels, Stories, Feed). Utiliza configurações de nível Hollywood/Broadcast para garantir máxima qualidade visual.

### ✨ Principais Benefícios

- 🎯 **Otimizado para Instagram**: Presets específicos para Reels (9:16) e Feed (16:9)
- ⚡ **Duplo modo de codificação**: 2-Pass para máxima qualidade, CRF para velocidade
- 🔧 **Configuração avançada**: Controle total sobre bitrate, CRF, presets e threading
- 📊 **Threading automático**: Utiliza todos os cores da CPU para máxima performance
- 🛡️ **Detecção automática**: Localiza FFmpeg automaticamente ou solicita caminho
- 📝 **Logs detalhados**: Registro completo de execução para debugging
- 🚀 **Interface amigável**: Menu interativo com validações e orientações

## 🚀 Características

### 🎥 Modos de Codificação
- **2-Pass Encoding**: Máxima qualidade com controle preciso de bitrate
- **CRF Encoding**: Codificação rápida com controle de qualidade constante

### ⚡ Otimizações V4
- **Threading Automático**: Utiliza todos os cores disponíveis
- **VBV Tuning Avançado**: Buffer otimizado para streaming
- **Psychovisual Enhancement**: Preservação máxima de detalhes
- **Fast Start**: Otimização para reprodução web

## 📋 Requisitos

### **Hardware Requirements**
- **OS:** Windows 10/11 (64-bit)
- **CPU:** Multi-core processor (2+ cores recommended)
- **RAM:** 4GB minimum, 8GB+ recommended
- **GPU:** Optional (NVIDIA RTX/GTX, Intel HD, AMD for acceleration)
- **Storage:** SSD recommended for optimal performance

### Software Necessário
- **FFmpeg** (versão 4.0 ou superior)
  - Disponível em: https://ffmpeg.org/download.html
  - Ou via package manager (chocolatey, scoop)



## 🔧 Instalação

### Método 1: Download Direto
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/instagram-encoder-framework.git
cd instagram-encoder-framework

### Método 2: Download Manual

1. Baixe o arquivo `Instagram_Encoder_Framework_FixV3.bat`
2. Coloque-o em uma pasta de sua escolha
3. Execute como Administrador (recomendado)

### Configuração do FFmpeg

O script tentará localizar o FFmpeg automaticamente. Se não encontrado:

- **Opção 1**: Adicione FFmpeg ao PATH do sistema
- **Opção 2**: O script solicitará o caminho completo durante a execução

## 🎬 Uso Básico

### Execução Simples
```batch
# Execute o script
Instagram_Encoder_Framework_FixV3.bat
```

### Fluxo de Trabalho

1. **Selecione o arquivo de entrada**
   ```
   Digite o nome do arquivo: meu_video.mp4
   ```

2. **Defina o arquivo de saída**
   ```
   Nome do arquivo de saída: video_instagram.mp4
   ```

3. **Escolha a resolução**
   - `1` - Reels/Stories (9:16) - 1080x1920
   - `2` - Feed (16:9) - 1920x1080

4. **Selecione o modo de codificação**
   - `D` = 2-PASS (duas passagens, máxima qualidade)
   - `C` = CRF (uma passagem, mais rápido)

5. **Configure parâmetros avançados** (ou use padrões)

## ⚙️ Configurações Avançadas

### Presets x264

| Preset | Velocidade | Qualidade | Uso Recomendado |
|--------|------------|-----------|-----------------|
| `medium` | Muito Rápido | Boa | Testes rápidos |
| `slow` | Rápido | Muito Boa | Uso geral |
| `slower` | Moderado | Alta | **Padrão (Recomendado)** |
| `veryslow` | Lento | Máxima | Projetos profissionais |

### Threading
```batch
Threading Automático: SIM (Recomendado)
# Utiliza todos os cores disponíveis
# Aceleração de 200-400% em CPUs modernas
```

### Configurações de Bitrate (2-Pass)

| Parâmetro | Valor Padrão | Descrição |
|-----------|--------------|-----------|
| Bitrate Alvo | 15M | Taxa de bits média desejada |
| Bitrate Máximo | 25M | Pico máximo permitido |
| Buffer Size | 30M | Tamanho do buffer VBV |

### Configurações CRF

| CRF | Qualidade | Tamanho | Uso |
|-----|-----------|---------|-----|
| 15-17 | Excelente | Grande | Arquivos master |
| 18 | Alta | Média | **Padrão** |
| 20-22 | Boa | Pequeno | Web otimizado |
| 23-25 | Aceitável | Muito Pequeno | Backup/Draft |

## 🔧 Parâmetros Técnicos

### **Encoding Standards**
- **Video Codec:** H.264 (libx264) with Hollywood-level parameters
- **Audio Codec:** AAC LC 48kHz Stereo (up to 320kbps)
- **Container:** MP4 with faststart optimization
- **Color Space:** BT.709 TV Range (Instagram native)
- **Pixel Format:** yuv420p (universal compatibility)

### **Supported Resolutions**
- **📱 Reels/Stories (9:16):** 1080x1920 @ 30fps
- **🔲 Feed Square (1:1):** 1080x1080 @ 30fps  
- **📺 Feed/IGTV (16:9):** 1920x1080 @ 30fps
- **🎬 Cinema (21:9):** 2560x1080 @ 30fps
- **⚙️ Custom:** User-defined resolutions

### **x264 Parameters (Hollywood-Level)**
```bash
# Professional encoding settings
🎬 VERSÃO HOLLYWOOD (Maximum Quality + Zero Recompression)
-x264opts "ref=5:bframes=3:b-adapt=2:direct=auto:me=umh:subme=8:trellis=2:partitions=p8x8,b8x8,i8x8,i4x4:8x8dct=1:cqm=flat:analyse=p8x8,b8x8,i8x8,i4x4:me-range=24:chroma-me=1:nr=25:no-fast-pskip=1:no-dct-decimate=1:cabac=1:deblock=1,-1,-1:aq-mode=2:aq-strength=0.8:rc-lookahead=60:mbtree=1:chroma-qp-offset=2" ^
-g 30 -keyint_min 15 -sc_threshold 40 ^
-r 30
```

### **Instagram Compliance Mode**
```bash
# Zero-recompression parameters
-pix_fmt yuv420p
-color_range tv  
-color_primaries bt709
-color_trc bt709
-colorspace bt709
-max_muxing_queue_size 9999
-movflags +faststart
```

### Configurações de Áudio
```bash
Codec: AAC
Bitrate: 320kbps (padrão)
Sample Rate: 48kHz
Canais: Stereo (2.0)
```

### Otimizações Avançadas
```bash
Psychovisual: psy-rd 1.0:0.15
Adaptive Quantization: Mode 2
VBV Init: 0.9 (streaming otimizado)
Fast Start: Habilitado (web)
Scene Detection: Desabilitado (consistência)
```

## 🛠️ Resolução de Problemas

### ❌ Problemas Comuns

**FFmpeg não encontrado**
```bash
ERRO: ffmpeg não encontrado no PATH
```
**Solução:**
- Baixe FFmpeg e adicione ao PATH do sistema
- Ou forneça o caminho completo quando solicitado

**Arquivo de entrada não encontrado**
```bash
ERRO: Arquivo 'video.mp4' não encontrado
```
**Solução:**
- Verifique se o arquivo existe no diretório atual
- Use caminho completo: `C:\Videos\meu_video.mp4`

**Erro durante codificação**
```bash
ERRO FATAL: FFmpeg encontrou um erro
```
**Solução:**
- Verifique se o arquivo não está corrompido
- Teste com outro arquivo de entrada
- Consulte o log de execução gerado

## 📊 Performance

### Codificação Lenta
- Reduza o preset: `slower → slow → medium`
- Use CRF: Mais rápido que 2-Pass
- Verifique CPU: Task Manager durante codificação

### Arquivo Final Muito Grande
- Aumente CRF: `18 → 20 → 22`
- Reduza bitrate alvo: `15M → 12M → 10M`
- Use preset mais rápido: Melhor compressão

## 📖 Exemplos

## 🎨 **Professional Profiles**

### **📱 Reels/Stories (Vertical)**
```
Resolution: 1080x1920 (9:16)
Mode: 2-Pass Encoding
Target Bitrate: 15M
Max Bitrate: 25M
Audio: 320k AAC
Preset: veryslow (maximum quality)
```

### **🔲 Feed Square**
```
Resolution: 1080x1080 (1:1)  
Mode: 2-Pass Encoding
Target Bitrate: 12M
Max Bitrate: 20M
Audio: 256k AAC
Preset: veryslow
```

### **📺 IGTV/Feed Horizontal**
```
Resolution: 1920x1080 (16:9)
Mode: 2-Pass Encoding  
Target Bitrate: 18M
Max Bitrate: 30M
Audio: 320k AAC
Preset: veryslow
```

### **🎬 Cinema Ultra-Wide**
```
Resolution: 2560x1080 (21:9)
Mode: 2-Pass Encoding
Target Bitrate: 25M
Max Bitrate: 40M
Audio: 320k AAC
Preset: placebo (maximum quality)
```

## 📝 Logs e Monitoramento

### Arquivos Gerados
```
video_instagram.mp4                    # Arquivo final
DD-MM-AAAA_HHhMM_instagram_exec.txt    # Log de execução
video_instagram_ffmpeg_passlog-*.log   # Logs 2-Pass (temporários)
```

### Interpretando Logs
```bash
[OK] FFmpeg localizado: ffmpeg
[OK] Arquivo de entrada: video.mp4
[OK] Codificação 2-pass concluída
```

## 🤝 Contribuindo

### Como Contribuir

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Reportando Bugs

- Use as Issues do GitHub
- Inclua logs de execução
- Descreva passos para reproduzir o problema

### Melhorias Desejadas

- [ ] Interface gráfica (GUI)
- [ ] Suporte a batch processing

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Gabriel Schoenardie**

- GitHub: [@seu-usuario](https://github.com/seu-usuario)
- Email: seu-email@exemplo.com

## 🙏 Agradecimentos

- **FFmpeg Team** - Pela excelente ferramenta de codificação
- **x264 Developers** - Pelo codec H.264 de alta qualidade
- **Comunidade Instagram** - Por feedback e testes

---

⭐ **Se este projeto foi útil para você, considere dar uma estrela no repositório!**
