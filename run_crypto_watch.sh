#!/bin/bash

echo "🚀 Starting CryptoWatch on Apple Watch Simulator..."

# Check if Apple Watch simulator is available
WATCH_ID=$(xcrun simctl list devices | grep "Apple Watch Series 9 (45mm)" | head -1 | grep -o '[A-F0-9-]\{36\}')

if [ -z "$WATCH_ID" ]; then
    echo "❌ Apple Watch simulator not found"
    exit 1
fi

echo "📱 Found Apple Watch simulator: $WATCH_ID"

# Boot the simulator if not already running
xcrun simctl boot "$WATCH_ID" 2>/dev/null || echo "✅ Simulator already running"

# Open Simulator app
open -a Simulator

echo "🔄 Building and running CryptoWatch..."

# Create a temporary Xcode project
TEMP_DIR=$(mktemp -d)
PROJECT_NAME="CryptoWatch"
PROJECT_DIR="$TEMP_DIR/$PROJECT_NAME"

mkdir -p "$PROJECT_DIR"
cp CryptoWatchSimple.swift "$PROJECT_DIR/ContentView.swift"

# Create Package.swift for the project
cat > "$PROJECT_DIR/Package.swift" << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CryptoWatch",
    platforms: [
        .watchOS(.v9),
        .iOS(.v16)
    ],
    products: [
        .executable(name: "CryptoWatch", targets: ["CryptoWatch"])
    ],
    targets: [
        .executableTarget(
            name: "CryptoWatch",
            dependencies: []
        )
    ]
)
EOF

# Create main.swift
cat > "$PROJECT_DIR/main.swift" << EOF
import SwiftUI

// Include the content from CryptoWatchSimple.swift here
// This would be the main entry point
EOF

echo "📦 Created temporary project at: $PROJECT_DIR"
echo "🎯 To run the full Apple Watch app:"
echo "   1. Open Xcode"
echo "   2. Create new watchOS app project"
echo "   3. Replace ContentView.swift with our CryptoWatchSimple.swift content"
echo "   4. Build and run on Apple Watch simulator"

echo ""
echo "🚀 For now, running the demo version..."
swift CryptoWatchDemo.swift

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Demo completed!" 