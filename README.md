# Instagram Encoder Framework

![Version](https://img.shields.io/badge/version-1.3-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![FFmpeg](https://img.shields.io/badge/requires-FFmpeg-red.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

> **Framework profissional para codificação de vídeos otimizados para Instagram com qualidade Hollywood/Broadcast**

---

**⚡ COPIE ESTE CÓDIGO COMPLETO E COLE NO SEU README.md ⚡**

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

### 📱 Formatos Suportados
- **Instagram Reels/Stories**: 1080x1920 (9:16) - Vertical
- **Instagram Feed**: 1920x1080 (16:9) - Horizontal
- **Framerate**: 30 FPS (otimizado para Instagram)

### ⚡ Otimizações V4
- **Threading Automático**: Utiliza todos os cores disponíveis
- **VBV Tuning Avançado**: Buffer otimizado para streaming
- **Psychovisual Enhancement**: Preservação máxima de detalhes
- **Fast Start**: Otimização para reprodução web

## 📋 Requisitos

### Sistema Operacional
- Windows 7/8/10/11 (32-bit ou 64-bit)

### Software Necessário
- **FFmpeg** (versão 4.0 ou superior)
  - Disponível em: https://ffmpeg.org/download.html
  - Ou via package manager (chocolatey, scoop)

### Hardware Recomendado
- **CPU**: Multi-core (4+ cores recomendado para threading)
- **RAM**: 4GB+ (8GB+ para vídeos 4K+)
- **Armazenamento**: Espaço livre equivalente a 2x o tamanho do vídeo original

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

### Configurações de Vídeo
```bash
Codec: H.264 (libx264)
Profile: High
Level: 4.1
Pixel Format: YUV 4:2:0
Colorspace: BT.709 (HD Standard)
B-frames: 3 (otimizado)
Reference Frames: 5
GOP Size: 30 (1 segundo)
```

### Configurações de Áudio
```bash
Codec: AAC
Bitrate: 192kbps (padrão)
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

### Exemplo 1: Reel Vertical Rápido
```batch
Entrada: video_original.mov
Saída: reel_vertical.mp4
Resolução: 1 (1080x1920)
Modo: C (CRF)
CRF: 20
Preset: slow
```

### Exemplo 2: Feed Horizontal Máxima Qualidade
```batch
Entrada: video_paisagem.mp4
Saída: feed_horizontal.mp4
Resolução: 2 (1920x1080)
Modo: D (2-PASS)
Bitrate Alvo: 18M
Bitrate Max: 30M
Preset: slower
```

### Exemplo 3: Stories Rápido
```batch
Entrada: stories_raw.mp4
Saída: stories_final.mp4
Resolução: 1 (1080x1920)
Modo: C (CRF)
CRF: 22
Preset: medium
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

- [ ] Suporte a hardware encoding (NVENC, Quick Sync)
- [ ] Interface gráfica (GUI)
- [ ] Presets automáticos por tipo de conteúdo
- [ ] Suporte a batch processing
- [ ] Detecção automática de resolução ótima

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
