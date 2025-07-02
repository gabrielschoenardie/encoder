#!/bin/bash
# Build and Package Tool - Instagram Encoder Framework V5.2 (Linux/Mac)

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                    🔨 BUILD SYSTEM - MODULAR EDITION                         ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

VERSION="5.2.0-modular"
BUILD_DIR="releases/v$VERSION"

echo "📦 Building Instagram Encoder Framework V$VERSION..."

# Create release directory
mkdir -p "releases"
mkdir -p "$BUILD_DIR"

# Copy source files with structure
echo "📁 Copying modular structure..."
cp -r src/ "$BUILD_DIR/"
cp -r docs/user-guide/ "$BUILD_DIR/docs/" 2>/dev/null || mkdir -p "$BUILD_DIR/docs"
cp README.md "$BUILD_DIR/" 2>/dev/null

# Create cross-platform launcher
echo "📝 Creating cross-platform launcher..."

# Windows launcher
cat > "$BUILD_DIR/InstagramEncoder.bat" << 'EOF'
@echo off
title Instagram Encoder Framework V5.2.0-modular
cd /d %~dp0
src\core\init.bat %*
EOF

# Linux/Mac launcher
cat > "$BUILD_DIR/InstagramEncoder.sh" << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
src/core/init.sh "$@"
EOF

chmod +x "$BUILD_DIR/InstagramEncoder.sh"

# Create package info
echo "📋 Creating package info..."
cat > "$BUILD_DIR/VERSION.txt" << EOF
Instagram Encoder Framework V$VERSION
Build Date: $(date)
Architecture: Modular
Platform: Cross-platform (Windows/Linux/Mac)
Entry Points:
  - Windows: InstagramEncoder.bat
  - Linux/Mac: InstagramEncoder.sh
EOF

# Create installation guide
echo "📝 Creating installation guide..."
cat > "$BUILD_DIR/INSTALL.md" << 'EOF'
# 🚀 Instagram Encoder Framework - Installation Guide

## Windows
```cmd
InstagramEncoder.bat
EOF