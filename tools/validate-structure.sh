#!/bin/bash
# Structure Validation Tool - Instagram Encoder Framework V5.2

echo "🔍 MODULAR ARCHITECTURE VALIDATION"
echo "=================================="
echo ""

PASSED=0
FAILED=0

# Function to test file/directory existence
test_exists() {
    local path="$1"
    local description="$2"

    if [ -e "$path" ]; then
        echo "✅ $description: $path"
        ((PASSED++))
    else
        echo "❌ $description: $path (NOT FOUND)"
        ((FAILED++))
    fi
}

# Test core structure
echo "📁 CORE STRUCTURE:"
test_exists "src/core" "Core module directory"
test_exists "src/core/encoderV5.bat" "Main encoder (Windows)"
test_exists "src/core/init.bat" "Initializer (Windows)"
test_exists "src/core/init.sh" "Initializer (Linux/Mac)"

echo ""
echo "⚙️ CONFIGURATION:"
test_exists "src/config" "Config directory"
test_exists "src/config/encoder_config.json" "Main configuration"

echo ""
echo "🎬 PROFILES:"
test_exists "src/profiles" "Profiles directory"
test_exists "src/profiles/presets" "Presets directory"
test_exists "src/profiles/presets/reels_9_16.prof" "Reels profile"

echo ""
echo "🛠️ TOOLS:"
test_exists "tools" "Tools directory"
test_exists "tools/build.bat" "Build script (Windows)"
test_exists "tools/validate-structure.sh" "Validation script (Linux/Mac)"

echo ""
echo "📚 DOCUMENTATION:"
test_exists "docs" "Documentation directory"
test_exists "docs/technical" "Technical docs directory"
test_exists "docs/user-guide" "User guide directory"
test_exists "README.md" "Main README"

echo ""
echo "🎯 GITHUB INTEGRATION:"
test_exists ".github" "GitHub directory"
test_exists ".github/ISSUE_TEMPLATE" "Issue templates directory"

echo ""
echo "📊 VALIDATION SUMMARY:"
echo "=================================="
echo "✅ Passed: $PASSED"
echo "❌ Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED! Modular architecture is complete."
    echo "🚀 Project is ready for development and deployment."
else
    echo "⚠️ Some components are missing. Please check the failed items above."
fi

echo ""
echo "📋 CONFIGURATION PREVIEW:"
if [ -f "src/config/encoder_config.json" ]; then
    echo "   Version: $(grep -o '"version":[^,]*' src/config/encoder_config.json)"
    echo "   Architecture: $(grep -o '"architecture":[^,]*' src/config/encoder_config.json)"
    echo "   Expert Mode: $(grep -o '"expert_mode":[^,]*' src/config/encoder_config.json)"
fi

echo ""
echo "🎬 AVAILABLE PROFILES:"
if [ -d "src/profiles/presets" ]; then
    for profile in src/profiles/presets/*.prof; do
        if [ -f "$profile" ]; then
            profile_name=$(basename "$profile" .prof)
            echo "   • $profile_name"
        fi
    done
fi

echo ""