# CryptoWatch - Apple Watch Crypto Tracker

A high-performance cryptocurrency tracking app designed exclusively for Apple Watch. Track your favorite cryptocurrencies with real-time price updates, search through 17,000+ coins, and manage your watchlist directly from your wrist.

## Features

### 🔍 **Comprehensive Search**

- Search through 17,000+ cryptocurrencies using CoinGecko's extensive database
- Real-time search with debounced API calls for optimal performance
- Instant results with detailed coin information

### ❤️ **Favorites Management**

- Add/remove coins to your personal favorites list
- Persistent storage using UserDefaults
- Swipe-to-delete functionality
- Real-time price updates every 5 seconds for favorite coins

### 📊 **Real-Time Price Tracking**

- Live price updates every 5 seconds
- 24-hour price change indicators with color coding
- Market cap, volume, and ranking information
- Formatted currency display with appropriate decimal places

### 📱 **Apple Watch Optimized UI**

- Native SwiftUI interface designed for Apple Watch
- Tab-based navigation (Favorites, Search, Top Coins)
- Pull-to-refresh functionality
- Optimized for all Apple Watch sizes (38mm to 49mm)

### 🏆 **Top Cryptocurrencies**

- View top 100 cryptocurrencies by market cap
- Real-time ranking and market data
- Quick access to add coins to favorites

### 📋 **Detailed Coin Information**

- Comprehensive coin details including:
  - Current price and 24h change
  - Market cap and trading volume
  - 24h high/low prices
  - Circulating, total, and max supply
  - All-time high and low records
  - Market cap ranking

## Technical Architecture

### 🏗️ **Architecture Pattern**

- **MVVM (Model-View-ViewModel)** architecture
- **ObservableObject** pattern for reactive UI updates
- **Combine** framework for reactive programming
- **Singleton** pattern for shared services

### 🔄 **Data Management**

- **CryptoService**: Handles all API communications with CoinGecko
- **FavoritesManager**: Manages persistent storage of favorite coins
- **Real-time Updates**: Timer-based price updates every 5 seconds
- **Efficient Caching**: Minimizes API calls through smart data management

### 🌐 **API Integration**

- **CoinGecko API**: Free tier with access to 17,000+ cryptocurrencies
- **RESTful API**: JSON-based data exchange
- **Rate Limiting**: Respectful API usage with debounced search
- **Error Handling**: Comprehensive error management and user feedback

### 📱 **UI Components**

- **ContentView**: Main tab navigation container
- **FavoritesView**: Displays and manages favorite cryptocurrencies
- **SearchView**: Search functionality with real-time results
- **TopCoinsView**: Shows top cryptocurrencies by market cap
- **CoinDetailView**: Detailed information for individual coins
- **CoinRowView**: Reusable component for displaying coin data

## Project Structure

```
CryptoWatch WatchKit App/
├── CryptoWatchApp.swift          # Main app entry point
├── ContentView.swift             # Tab navigation container
├── Models/
│   └── CryptoCoin.swift          # Cryptocurrency data model
├── Services/
│   ├── CryptoService.swift       # API service for CoinGecko
│   └── FavoritesManager.swift    # Favorites persistence manager
├── Views/
│   ├── FavoritesView.swift       # Favorites list and management
│   ├── SearchView.swift          # Search functionality
│   ├── TopCoinsView.swift        # Top cryptocurrencies display
│   ├── CoinRowView.swift         # Reusable coin display component
│   └── CoinDetailView.swift      # Detailed coin information
├── Assets.xcassets/              # App icons and colors
└── Info.plist                   # App configuration
```

## Requirements

- **Apple Watch Series 4 or later**
- **watchOS 9.0 or later**
- **Internet connection** for real-time data
- **Xcode 15.0 or later** for development

## Installation & Setup

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd crypto-watch
   ```

2. **Open in Xcode**:

   ```bash
   open CryptoWatch.xcodeproj
   ```

3. **Configure signing**:

   - Select your development team in project settings
   - Ensure proper provisioning profiles are set up

4. **Build and run**:
   - Select Apple Watch simulator or connected device
   - Press Cmd+R to build and run

## API Information

### CoinGecko API

- **Base URL**: `https://api.coingecko.com/api/v3`
- **Rate Limits**: Free tier allows reasonable usage
- **Data Coverage**: 17,000+ cryptocurrencies
- **Update Frequency**: Real-time market data

### Key Endpoints Used:

- `/coins/markets` - Market data for cryptocurrencies
- `/search` - Search functionality
- `/coins/{id}` - Detailed coin information

## Performance Optimizations

### 🚀 **High Performance Features**

- **Debounced Search**: Prevents excessive API calls during typing
- **Efficient Updates**: Only updates displayed data
- **Memory Management**: Proper cleanup of timers and subscriptions
- **Optimized UI**: Minimal redraws and efficient list rendering

### ⚡ **Real-Time Updates**

- **5-Second Intervals**: Automatic price updates for favorites
- **Background Updates**: Continues updating when app is active
- **Smart Refresh**: Only fetches data for visible coins

## Customization

### 🎨 **Theming**

- **Accent Color**: Orange theme (#FF7A00)
- **Dark Mode**: Full support for dark/light modes
- **Color Coding**: Green for gains, red for losses

### ⚙️ **Configuration**

- **Update Interval**: Modify timer interval in `CryptoService`
- **API Endpoints**: Easily configurable base URLs
- **Display Options**: Customizable number formatting

## Troubleshooting

### Common Issues:

1. **No data loading**: Check internet connection
2. **Search not working**: Verify API accessibility
3. **Favorites not saving**: Check UserDefaults permissions
4. **Performance issues**: Restart app to clear cache

### Debug Mode:

- Enable debug logging in `CryptoService`
- Monitor API response times
- Check memory usage in Xcode

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **CoinGecko** for providing free cryptocurrency API
- **Apple** for SwiftUI and WatchKit frameworks
- **Community** for feedback and contributions

## Future Enhancements

- [ ] Price alerts and notifications
- [ ] Portfolio tracking with holdings
- [ ] Historical price charts
- [ ] Complications for watch faces
- [ ] Haptic feedback for price changes
- [ ] Multiple currency support
- [ ] Offline mode with cached data

---

**Built with ❤️ for Apple Watch**
