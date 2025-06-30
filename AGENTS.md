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
| InstagramEncoderV5 | Batch   | Encoder H.264 Two-Pass, presets Hollywood/IG         | Prompts interativos  | Vídeo MP4 otimizado   | Batch, FFmpeg |

---

## 📜 Purpose of This Document

AGENTS.md serves as the **authoritative reference** for:

✅ What each script does  
✅ How scripts communicate  
✅ Inputs/outputs  
✅ Expected usage patterns  
✅ Extension guidelines  

> This is your developer contract for understanding and maintaining the encoding framework.

---

## 📑 Agent Index

- [START_ENCODER.bat](#start_encoderbat)
- [encoderV5.bat](#encoderv5bat)
- [FFmpeg (External Dependency)](#ffmpeg-external-dependency)
- [Logs](#logs)
- [Configuration](#configuration)
- [Design Principles](#design-principles)
- [Extending Agents](#extending-agents)

---

## ⚡ START_ENCODER.bat

**Type:** Launcher Agent  
**Role:**  
- Acts as the user-friendly entry point.  
- Opens Windows Terminal or CMD and starts the main encoder script.  
- Ensures the user runs the encoder with proper console settings.

**Interface:**  
- **Input:** None (no user prompts).  
- **Output:** Opens `encoderV5.bat` in a new terminal window.  

**Behavior:**  
- Simplifies user interaction on Windows.  
- No encoding logic is contained here.  
- Minimal maintenance required.

**Best Practices for Maintainers:**  
- Keep it minimal.  
- Avoid hardcoded absolute paths.  
- Test compatibility with both Windows Terminal and classic CMD.

---

## ⚡ encoderV5.bat

**Type:** Core Agent  
**Role:**  
- Main user-facing batch script.  
- Contains full interactive encoding workflow.  
- Collects user input, validates it, runs FFmpeg commands.

**Interface:**  
- **Input:** Interactive prompts for:
  - Input video path
  - Output filename
  - Encoding profile (e.g. Reels, Feed)
  - Target bitrate
  - Maximum bitrate
  - x264 preset
- **Output:**
  - Encoded Instagram-ready MP4 file
  - Execution log file with detailed metadata

**Technical Responsibilities:**  
- Enforce 2-Pass encoding only.  
- Detect FFmpeg in PATH or ask user for path.  
- Auto-backup of existing output files before overwrite.  
- Log all operations with timestamps.  
- Validate inputs before executing FFmpeg.

**Behavioral Notes:**  
- Structured with GOTO labels for clarity.  
- Uses ECHO for user prompts and feedback.  
- Provides consistent color scheme if desired.

---

## ⚡ FFmpeg (External Dependency)

**Type:** External Binary Dependency  
**Role:**  
- The actual encoder doing the heavy lifting.  
- Must be installed by the user separately.

**Requirements:**  
- FFmpeg v4.0+ recommended for best compatibility.  
- Must support libx264, AAC LC audio.

**Integration Details:**  
- Auto-detected in PATH by the script.  
- User can specify full path manually if needed.  
- All encoding relies on FFmpeg’s CLI interface.

**Encoding Guarantees:**  
- H.264 High@4.1 profile  
- yuv420p pixel format  
- BT.709 color space compliance  
- +faststart optimization for streaming

---

## ⚡ Logs

**Type:** Output Artifact  
**Purpose:**  
- Captures full details of each encoding session.  
- Supports auditing and debugging.

**Contents:**  
- User-provided parameters  
- FFmpeg commands executed  
- Errors and warnings  
- Timestamps for all steps

**Naming Convention:**  

DD-MM-YYYY_HHhMM_instagram_exec.txt

**Location:**  
- Default: Same directory as the script unless configured otherwise.

**Usage Notes:**  
- Always check logs after failed encodes.  
- Safe to share for support/debugging (no sensitive personal data except filenames).

---

## ⚡ Configuration

**Current Features:**  
- Fully interactive setup:
  - User inputs for all key parameters.
  - Profile-based aspect ratio presets.
  - Target and maximum bitrate control.
  - x264 preset selection (medium, slow, slower, veryslow).

**Planned Enhancements (Suggestions):**  
- Optional config files (e.g., `.ini`, `.env`) for default settings.  
- Command-line arguments to bypass prompts for automation.  
- User-defined profiles stored in a config folder.

---

## ⚙️ Design Principles

✅ **Single Responsibility:**  
- Each script has a clear, minimal, well-defined purpose.  
- Launcher vs. Encoder separation improves maintainability.

✅ **Portability:**  
- Compatible with Windows 10/11 CMD and Windows Terminal.  
- No platform-dependent hardcoding.

✅ **Safety First:**  
- Input validation to avoid incorrect commands.  
- Backup system prevents overwriting existing output files.

✅ **Instagram Compliance:**  
- Ensures correct encoding settings:
  - Aspect ratios and resolutions.
  - BT.709 color primaries, yuv420p format.
  - +faststart for instant playback.

✅ **Transparency:**  
- User prompted for all critical settings.  
- Logs generated automatically for troubleshooting.

✅ **Extensibility:**  
- Easy to add new encoding profiles.  
- Structured prompts and FFmpeg calls make extensions predictable.

---

## 🛠️ Extending Agents

**Conventions for New Scripts:**  
- Use clear UPPERCASE_WITH_UNDERSCORES naming.  
- Start with header comments explaining:
  - Purpose
  - Inputs
  - Outputs
  - Dependencies
- Validate all user inputs.  
- Log every command or significant action.  
- Include backup/overwrite warnings when creating files.  
- Keep consistent console colors and prompt styles.

**Recommended Agent Template:**  
```batch
REM ========================================
REM [AGENT NAME]
REM Purpose: One-line description
REM Inputs: Expected user inputs
REM Outputs: Files generated or modified
REM Dependencies: FFmpeg or other binaries
REM ========================================

Example New Agents to Consider:

CLEAN_LOGS.bat: Purge old log files.
VERIFY_OUTPUT.bat: Validate encoded video with FFprobe.
PROFILE_BUILDER.bat: Help users create custom encoding profiles.

📜 Example Agent Execution Flow

flowchart TD
  User -->|runs| START_ENCODER.bat
  START_ENCODER.bat --> encoderV5.bat
  encoderV5.bat -->|calls| FFmpeg
  FFmpeg -->|produces| Encoded_MP4
  encoderV5.bat -->|writes| Log_File

## 🧩 Mini-Diagrama de Fluxo

[Vídeo original] --> [InstagramEncoderV5 (Batch + FFmpeg)]
                      |
                      v
        [Vídeo MP4 otimizado para Instagram]
                      |
        [Upload manual e sucesso garantido]

---

🔎 Maintenance & Versioning
Best Practices:
Tag stable versions in Git (e.g., v5.0).
Maintain a CHANGELOG.md with new features, fixes, breaking changes.
Keep AGENTS.md up to date with new or removed scripts.
Test changes on both Windows 10 and 11 for compatibility.
Encourage PRs that maintain these documentation standards.

📄 License
This project is licensed under the MIT License. See LICENSE for details.

👨‍💻 Author
Gabriel Schoenardie
GitHub: @your-username

⭐ If you find this project useful, please consider starring the repo!

---

## 💡 Features of this *advanced* AGENTS.md
✅ Designed for developers and maintainers  
✅ Includes roles, inputs/outputs, usage notes  
✅ Clean interface contracts for each agent  
✅ Maintenance guidelines and naming conventions  
✅ Extension strategy with example template  
✅ Mermaid diagram to visualize execution flow

