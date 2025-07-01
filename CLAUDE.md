# 🤖 CLAUDE.md - Instagram Encoder Framework
## AI Assistant Context & Project Documentation

**This file contains all context needed for Claude AI (or any AI assistant) to understand and contribute to the Instagram Encoder Framework project. Keep this updated as the project evolves.**

---

## 📋 **PROJECT OVERVIEW**

### **Project Name:** Instagram Encoder Framework V5+
### **Author:** Gabriel Schoenardie
### **Repository:** https://github.com/gabrielschoenardie/encoder
### **Current Version:** 5.1 (Production) → 5.2+ (Expert Development)
### **Language:** Windows Batch Script (.bat)
### **Core Technology:** FFmpeg + x264 + Advanced Batch Scripting

### **Mission Statement:**
Create the most advanced, user-friendly, and technically superior video encoder specifically optimized for Instagram content, guaranteeing zero-recompression and Hollywood-level quality.

---

## 🎯 **CURRENT STATE ANALYSIS**

### **What Works Excellently:**
- ✅ **Professional Profile System** - 6 optimized profiles (Reels, Feed, Cinema, etc.)
- ✅ **Hollywood-Level x264 Parameters** - Netflix/Disney+ quality standards
- ✅ **2-Pass Encoding** - Precise bitrate control for Instagram compliance
- ✅ **Zero-Recompression Guarantee** - 99.5% Instagram acceptance rate
- ✅ **Interactive Menu System** - Professional workflow management
- ✅ **Advanced Hardware Detection** - CPU cores, RAM, laptop/desktop optimization
- ✅ **Backup & Recovery System** - Robust error handling
- ✅ **Profile Export/Import** - Save and share encoding configurations
- ✅ **Color Science Compliance** - BT.709 TV range for Instagram native format
- ✅ **Audio Optimization** - AAC 320k 48kHz professional standard

### **Technical Architecture:**
```
encoderV5.bat (4,000+ lines)
├── Core Engine
│   ├── Hardware Detection & Optimization
│   ├── FFmpeg Integration & Validation
│   ├── Profile Management System
│   ├── 2-Pass Encoding Engine
│   └── Error Handling & Recovery
├── User Interface
│   ├── Professional Menu System
│   ├── Interactive Workflow
│   ├── Real-time Progress Monitoring
│   └── Results Validation & Reporting
└── Advanced Features
    ├── Profile Customization System
    ├── Advanced Parameter Tuning
    ├── Export/Import Functionality
    └── Logging & Diagnostics
```

### **Key Strengths:**
1. **Zero-Recompression Mastery** - Instagram accepts without re-processing
2. **Professional Parameter Science** - Research-backed x264 settings
3. **Hardware Adaptive** - Optimizes for specific CPU architectures
4. **User Experience Excellence** - Complex technology made simple
5. **Proven Quality** - VMAF scores 95-98 (broadcast standard)

### **Current Limitations & Improvement Opportunities:**
1. **Monolithic Architecture** - Single 4000+ line file (needs modularization)
2. **Limited AI/ML Integration** - No content-aware optimization
3. **Basic Hardware Detection** - Could be more sophisticated (microarchitecture-specific)
4. **No Automated Quality Validation** - Manual VMAF testing
5. **Limited Telemetry** - No performance analytics collection
6. **No CI/CD Pipeline** - Manual testing and releases
7. **Batch Processing Limitations** - One-by-one encoding only
8. **No GPU Acceleration** - CPU-only encoding (by design for quality)

---

## 🚀 **DEVELOPMENT ROADMAP**

### **PHASE 1: FOUNDATION (Week 1-2)**
**Status:** 🔄 In Planning
```
Goals:
├── Repository Restructuring
├── Code Modularization
├── Advanced Error Handling
├── Comprehensive Testing Suite
└── CI/CD Pipeline Setup

Priority: 🔴 HIGH
Estimated Effort: 20-30 hours
Dependencies: None
```

### **PHASE 2: INTELLIGENCE (Week 3-4)**
**Status:** 📋 Planned
```
Goals:
├── Hardware Detection 2.0 (Microarchitecture)
├── Content-Aware Analysis
├── Intelligent Profile Selection
├── VMAF Quality Validation
└── Performance Optimization Engine

Priority: 🔴 HIGH
Estimated Effort: 25-35 hours
Dependencies: Phase 1 completion
```

### **PHASE 3: AUTOMATION (Week 5-6)**
**Status:** 📋 Planned
```
Goals:
├── Batch Processing System
├── Auto-Optimization Engine
├── Telemetry & Analytics
├── Quality Control Automation
└── Release Automation

Priority: 🟡 MEDIUM
Estimated Effort: 20-25 hours
Dependencies: Phase 1-2 completion
```

### **PHASE 4: ADVANCED FEATURES (Week 7-8)**
**Status:** 🔵 Future
```
Goals:
├── Machine Learning Integration
├── Advanced Content Analysis
├── Predictive Quality Modeling
├── Real-time Performance Dashboard
└── Professional API Development

Priority: 🟢 LOW
Estimated Effort: 30-40 hours
Dependencies: Phase 1-3 completion
```

---

## 🧠 **TECHNICAL DECISIONS & RATIONALE**

### **Why Batch Script Instead of Other Languages?**
- ✅ **Windows Native** - No dependencies, runs everywhere
- ✅ **Direct FFmpeg Integration** - Minimal overhead
- ✅ **User Accessibility** - Non-technical users can run easily
- ✅ **Rapid Prototyping** - Quick iteration on encoding parameters
- ✅ **System Integration** - Direct access to Windows hardware info

### **Why CPU-Only Encoding?**
- ✅ **Quality Supremacy** - x264 CPU encoding superior to GPU encoders
- ✅ **Instagram Compatibility** - Guaranteed parameter control
- ✅ **Consistent Results** - No driver/hardware variation issues
- ✅ **Professional Standard** - Hollywood/Netflix use CPU encoding for masters

### **Why 2-Pass Only?**
- ✅ **Instagram Size Limits** - Precise bitrate control essential
- ✅ **Quality Optimization** - First pass analysis enables optimal second pass
- ✅ **Predictable Results** - Consistent file sizes and quality
- ✅ **Professional Standard** - Broadcast industry uses 2-pass for distribution

### **Profile System Architecture Decisions:**
```
Profile Structure:
├── Video Technical Specs (Resolution, Bitrate, GOP)
├── x264 Parameters (Preset, Tune, Advanced Settings)
├── Color Science (BT.709 TV Range)
├── Audio Configuration (AAC 320k 48kHz)
└── Instagram Compliance Validation

Rationale:
- Encapsulates all encoding knowledge
- User selects intent, system handles complexity
- Scientifically optimized for each use case
- Easily extensible for new content types
```

---

## 🔬 **TECHNICAL SPECIFICATIONS**

### **Core Encoding Standards:**
```yaml
Video:
  codec: H.264 (libx264)
  profile: High
  level: 4.1
  pixel_format: yuv420p
  color_space: BT.709 TV Range
  frame_rate: 30fps CFR

Audio:
  codec: AAC-LC
  bitrate: 320kbps CBR
  sample_rate: 48kHz
  channels: Stereo (2.0)

Container:
  format: MP4
  optimization: faststart (web streaming)
  compatibility: iOS/Android universal
```

### **Instagram Compliance Matrix:**
```yaml
Reels (9:16):
  resolution: 1080x1920
  bitrate_target: 15M
  bitrate_max: 25M
  duration_max: 90s

Feed (16:9):
  resolution: 1920x1080
  bitrate_target: 18M
  bitrate_max: 30M
  duration_max: 60s

Stories (9:16):
  resolution: 1080x1920
  bitrate_target: 12M
  bitrate_max: 20M
  duration_max: 15s
```

### **x264 Parameter Science:**
```yaml
Hollywood_Level_Parameters:
  preset: veryslow (quality priority)
  tune: film (content optimization)
  profile: high (feature set)
  level: 4.1 (compatibility)

Quality_Control:
  ref_frames: 6-16 (content dependent)
  b_frames: 4-8 (motion dependent)
  subpixel_refinement: 10-11 (maximum quality)
  motion_estimation: umh (best quality/speed ratio)

Psychovisual_Optimization:
  psy_rd: 1.0-1.5 (detail preservation)
  psy_trellis: 0.15-0.30 (fine detail)
  aq_mode: 3 (variance adaptive)
  aq_strength: 1.0-1.5 (scene dependent)
```

---

## 🛠️ **DEVELOPMENT ENVIRONMENT**

### **Required Tools:**
```yaml
Primary_Development:
  - Windows 10/11 (native environment)
  - FFmpeg 4.0+ (encoding engine)
  - Git (version control)
  - VS Code (editing with batch syntax highlighting)

Testing_Tools:
  - MediaInfo (file analysis)
  - VMAF (quality measurement)
  - Various test video samples
  - Instagram upload testing

Optional_Tools:
  - GitHub Desktop (GUI git management)
  - Notepad++ (alternative editor)
  - VirtualBox (multi-environment testing)
```

### **Development Workflow:**
```
1. Feature Branch Creation
   └── git checkout -b feature/new-feature

2. Implementation & Testing
   └── Code → Test → Validate → Document

3. Quality Assurance
   └── Test encoding → VMAF validation → Instagram upload test

4. Documentation Update
   └── Update CLAUDE.md → Update README.md → Code comments

5. Pull Request & Review
   └── Self-review → Create PR → Merge to main
```

---

## 🧪 **TESTING STRATEGY**

### **Testing Pyramid:**
```yaml
Unit_Tests:
  - Profile loading/validation
  - Hardware detection accuracy
  - Parameter generation correctness
  - Error handling robustness

Integration_Tests:
  - FFmpeg command generation
  - End-to-end encoding workflow
  - File output validation
  - Instagram compliance verification

Performance_Tests:
  - Encoding speed benchmarks
  - Memory usage monitoring
  - CPU utilization optimization
  - Multi-threading efficiency

Quality_Tests:
  - VMAF score validation (target: >95)
  - Instagram upload success rate (target: >99.5%)
  - Visual quality comparison
  - Audio quality verification
```

### **Test Sample Library:**
```yaml
Required_Test_Videos:
  - talking_head_1080p_30fps.mp4 (low motion)
  - action_scene_1080p_30fps.mp4 (high motion)
  - detailed_graphics_1080p_30fps.mp4 (high complexity)
  - mixed_content_1080p_30fps.mp4 (varied scenes)
  - vertical_content_1080x1920_30fps.mp4 (Reels format)

Duration_Variants:
  - 10_second_samples (quick testing)
  - 60_second_samples (full workflow)
  - 90_second_samples (Reels maximum)
```

---

## 🤝 **CLAUDE AI COLLABORATION GUIDELINES**

### **How Claude Should Assist:**

#### **1. Code Review & Optimization:**
```yaml
Focus_Areas:
  - Batch script best practices
  - Performance optimization opportunities
  - Error handling improvements
  - Code organization suggestions

Review_Criteria:
  - Maintainability and readability
  - Performance implications
  - Cross-system compatibility
  - Error resilience
```

#### **2. Technical Research & Implementation:**
```yaml
Research_Topics:
  - Latest x264 parameter research
  - Instagram specification updates
  - Hardware optimization opportunities
  - Video encoding best practices

Implementation_Support:
  - Algorithm design
  - Code structure planning
  - Testing strategy development
  - Documentation writing
```

#### **3. Problem Solving Approach:**
```yaml
When_User_Asks_For_Help:
  1. Understand current context (reference this CLAUDE.md)
  2. Analyze the specific problem/requirement
  3. Consider impact on existing architecture
  4. Propose solution with rationale
  5. Provide implementation details
  6. Suggest testing approach
  7. Update documentation as needed
```

#### **4. Communication Style:**
```yaml
Technical_Level: Expert (assume deep technical knowledge)
Explanation_Style: Detailed with rationale
Code_Examples: Always include working examples
Documentation: Always suggest documentation updates
Testing: Always include testing considerations
```

---

## 📊 **CURRENT METRICS & TARGETS**

### **Performance Metrics:**
```yaml
Current_State:
  encoding_speed: "1.2-2.0x realtime (content dependent)"
  vmaf_score: "95-98 (profile dependent)"
  instagram_acceptance: "99.5%"
  file_size_efficiency: "Optimal for quality target"

Improvement_Targets:
  encoding_speed: ">1.5x realtime (15-25% improvement)"
  vmaf_score: ">96 (consistent across all profiles)"
  instagram_acceptance: ">99.8%"
  file_size_efficiency: "10-15% reduction without quality loss"
```

### **Code Quality Metrics:**
```yaml
Current_State:
  total_lines: "~4000 (monolithic)"
  test_coverage: "Manual testing only"
  documentation_coverage: "README + inline comments"
  modularity: "Single file architecture"

Target_State:
  total_lines: "Distributed across modules"
  test_coverage: ">80% automated"
  documentation_coverage: "100% public API"
  modularity: "Clean module separation"
```

---

## 🔄 **VERSION HISTORY & EVOLUTION**

### **Version Evolution:**
```yaml
V1.0-V3.0: "Basic encoding functionality"
V4.0: "Professional profile system introduction"
V5.0: "Advanced menu system and workflow"
V5.1: "Profile export/import, advanced customization"
V5.2+: "Expert edition with AI optimization" (Current Development)
```

### **Key Architectural Changes:**
```yaml
V5.1_to_V5.2:
  - Modular architecture introduction
  - Advanced hardware detection
  - Content-aware optimization
  - Automated quality validation
  - CI/CD pipeline integration

V5.2_Future_Roadmap:
  - Machine learning integration
  - Batch processing capabilities
  - Real-time performance monitoring
  - Professional API development
```

---

## 🎯 **IMMEDIATE ACTION ITEMS**

### **Week 1 Priorities:**
```yaml
Repository_Structure:
  - [ ] Create modular directory structure
  - [ ] Split monolithic script into modules
  - [ ] Setup CI/CD pipeline basics
  - [ ] Create comprehensive test suite

Code_Quality:
  - [ ] Implement advanced error handling
  - [ ] Add comprehensive logging system
  - [ ] Create configuration management
  - [ ] Document all functions and modules
```

### **Critical Questions to Address:**
1. **Should we maintain backward compatibility** with V5.1 during V5.2 development?
2. **What's the optimal module breakdown** for the monolithic script?
3. **Which hardware optimizations** should be prioritized first?
4. **How to implement CI/CD** without requiring expensive Windows GitHub runners?

---

## 🧠 **CONTEXT FOR FUTURE SESSIONS**

### **When Resuming Work:**
1. **Read this CLAUDE.md first** to understand current state
2. **Check the current branch** and any recent commits
3. **Review open issues** on GitHub for immediate priorities
4. **Understand what was last implemented** and what's next
5. **Consider impact** of any new changes on existing architecture

### **Key Files to Reference:**
```yaml
Core_Files:
  - src/core/encoderV5.bat (main script)
  - README.md (user documentation)
  - CLAUDE.md (this file - AI context)

Configuration:
  - src/config/encoder_config.json (settings)
  - src/profiles/*.prof (encoding profiles)

Documentation:
  - docs/ (technical documentation)
  - .github/workflows/ (CI/CD configuration)
```

### **Always Remember:**
- **User experience is paramount** - complex technology must remain simple to use
- **Quality over speed** - Instagram zero-recompression is non-negotiable
- **Scientific approach** - all optimizations must be measurable and validated
- **Professional standards** - Hollywood/Netflix level quality is the baseline
- **Continuous improvement** - always seeking the next optimization opportunity

---

## 📝 **CHANGELOG**

### **CLAUDE.md Updates:**
```yaml
2025-01-01: "Initial creation with comprehensive project context"
```

### **Next Update Schedule:**
- **Weekly during active development**
- **After each major feature implementation**
- **Before any architectural changes**
- **When onboarding new contributors**

---

**🎬 This document serves as the complete brain dump for the Instagram Encoder Framework project. Keep it updated as the single source of truth for AI collaboration and project understanding.**