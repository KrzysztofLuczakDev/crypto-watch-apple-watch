#!/bin/bash

# CryptoWatch Apple Watch App Setup Script
# This script helps set up the development environment

echo "🚀 Setting up CryptoWatch Apple Watch App..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

echo "✅ Xcode found"

# Check Xcode version
XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{print $2}')
echo "📱 Xcode version: $XCODE_VERSION"

# Check if we're in the right directory
if [ ! -f "CryptoWatch.xcodeproj/project.pbxproj" ]; then
    echo "❌ Please run this script from the crypto-watch directory"
    exit 1
fi

echo "✅ Project structure verified"

# Create necessary directories if they don't exist
mkdir -p "CryptoWatch WatchKit App/Models"
mkdir -p "CryptoWatch WatchKit App/Services"
mkdir -p "CryptoWatch WatchKit App/Views"
mkdir -p "CryptoWatch WatchKit App/Assets.xcassets/AppIcon.appiconset"
mkdir -p "CryptoWatch WatchKit App/Assets.xcassets/AccentColor.colorset"

echo "✅ Directory structure created"

# Check for internet connectivity (needed for CoinGecko API)
if ping -c 1 api.coingecko.com &> /dev/null; then
    echo "✅ Internet connectivity verified - CoinGecko API accessible"
else
    echo "⚠️  Warning: Cannot reach CoinGecko API. Check your internet connection."
fi

# Display project information
echo ""
echo "📊 Project Information:"
echo "   • App Name: CryptoWatch"
echo "   • Platform: Apple Watch (watchOS 9.0+)"
echo "   • Language: Swift 5.0"
echo "   • Framework: SwiftUI"
echo "   • API: CoinGecko (Free tier)"
echo "   • Features: Real-time crypto tracking, search, favorites"
echo ""

echo "🎯 Next Steps:"
echo "   1. Open CryptoWatch.xcodeproj in Xcode"
echo "   2. Select your development team in project settings"
echo "   3. Choose Apple Watch simulator or connected device"
echo "   4. Build and run (Cmd+R)"
echo ""

echo "📚 Documentation:"
echo "   • README.md - Complete project documentation"
echo "   • Project structure follows MVVM architecture"
echo "   • Real-time updates every 5 seconds"
echo "   • Search through 17,000+ cryptocurrencies"
echo ""

echo "🔧 Troubleshooting:"
echo "   • Ensure Apple Watch simulator is available"
echo "   • Check internet connection for API access"
echo "   • Verify watchOS deployment target (9.0+)"
echo ""

echo "✨ Setup complete! Ready to build your crypto tracking app."

# Optional: Open the project in Xcode
read -p "🚀 Would you like to open the project in Xcode now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Opening CryptoWatch.xcodeproj..."
    open CryptoWatch.xcodeproj
fi

echo "Happy coding! 🎉" 