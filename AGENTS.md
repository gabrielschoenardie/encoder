# AGENTS.md

![Hollywood Ready](https://img.shields.io/badge/Hollywood--Ready-🎬-gold?style=for-the-badge&logo=filmstrip&logoColor=white)
![FFmpeg](https://img.shields.io/badge/FFmpeg-H.264-green?logo=ffmpeg)
![Instagram Ready](https://img.shields.io/badge/Instagram-Ready-purple)

> ⚡️ **Documentação oficial do encoder profissional de vídeos para Instagram – padrão Hollywood e máxima compatibilidade.**  
> Projeto para criadores, editores e agências que buscam qualidade cinematográfica, automação e workflow sem stress.

---

## 📦 Lista de Agentes/Scripts

| Nome do Agente     | Tipo    | Função Principal                                     | Input                | Output                | Tecnologias   |
|--------------------|---------|------------------------------------------------------|----------------------|-----------------------|---------------|
| InstagramEncoderV3 | Batch   | Encoder H.264 CRF/Two-Pass, presets Hollywood/IG     | Prompts interativos  | Vídeo MP4 otimizado   | Batch, FFmpeg |

---

## 🎬 Caso de Uso Nerd-Expert

1. Finalize o vídeo no editor (Premiere, DaVinci, After, etc).
2. Exporte em máxima qualidade (ProRes, DNxHD, ou H.264 bruto).
3. Execute o **InstagramEncoderV3**: responda aos prompts inteligentes.
4. Receba um `.mp4` perfeito, sem surpresas, pronto para upload no Instagram.
5. Compartilhe orgulhosamente nos Reels, Stories ou Feed, sabendo que está “Hollywood Ready”.

---

## 🔎 Detalhes do InstagramEncoderV3

- **Descrição Nerd:**  
  Script batch para Windows, codifica vídeos para Instagram com parâmetros inspirados em pipelines de pós-produção de Hollywood.  
  Automatiza o FFmpeg, valida resoluções, CRF e bitrates, e protege seu workflow contra erros clássicos.

- **Entradas:**
  - Caminho do vídeo de entrada
  - Resolução recomendada para Instagram (ex: 1080x1350, 1080x1920, quadrado, etc)
  - Modo CRF ou Two-Pass
  - Valor CRF (17–22 = “cinema”)
  - Bitrate personalizado (modo Two-Pass, para nerds exigentes)
  - Flags técnicas opcionais

- **Saída:**
  - Arquivo `.mp4` pronto para upload, compatível 100% com Instagram Feed, Stories ou Reels
  - Log com feedback e dicas

- **Diferenciais Hollywood:**
  - Prompts interativos, user-friendly até para iniciantes
  - Validação dinâmica (nunca erre CRF ou bitrate de novo!)
  - Mensagens didáticas e dicas de workflow (“Quer 4K? Vai perder tempo, IG converte tudo pra 1080p!”)
  - Pode ser integrado em scripts-mestre, automações ou chamado via Task Scheduler

---

## 🧩 Mini-Diagrama de Fluxo

```text
[Vídeo original] --> [InstagramEncoderV3 (Batch + FFmpeg)]
                      |
                      v
        [Vídeo MP4 otimizado para Instagram]
                      |
             [Upload manual e sucesso garantido]

---

## 🚀 Guia Rápido de Uso

1. Certifique-se de ter o **FFmpeg** instalado e configurado no `PATH`.
2. Clone este repositório ou baixe o script `InstagramEncoderV3.bat`.
3. Abra o terminal do Windows, navegue até a pasta do script e execute `Instagram_Encoder_Framework_FixV3.bat`.
4. Siga os prompts interativos para definir resolução, modo de encode e demais parâmetros.
5. Seu vídeo otimizado será salvo na mesma pasta, pronto para upload no Instagram.

### Dicas Extras

- Utilize o modo **CRF** para qualidade visual equilibrada.
- Se precisar de controle total sobre o tamanho final do arquivo, opte pelo modo **Two-Pass**.
- Para resultados consistentes, mantenha suas fontes de vídeo em formatos profissionais (ProRes, DNxHD ou H.264 sem compressão adicional).

