#!/usr/bin/env swift

import Foundation

// MARK: - Models
struct CryptoCoin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
    }
    
    var formattedPrice: String {
        guard let price = currentPrice else { return "N/A" }
        return String(format: "$%.2f", price)
    }
    
    var formattedPriceChange: String {
        guard let change = priceChangePercentage24h else { return "N/A" }
        let sign = change >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))%"
    }
    
    var priceChangeColor: String {
        guard let change = priceChangePercentage24h else { return "gray" }
        return change >= 0 ? "green" : "red"
    }
}

// MARK: - Crypto Service
class CryptoService {
    static let shared = CryptoService()
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    private init() {}
    
    func fetchTopCoins(completion: @escaping ([CryptoCoin]) -> Void) {
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion([])
            return
        }
        
        print("🔄 Fetching top cryptocurrencies...")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                completion([])
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
                print("✅ Successfully fetched \(coins.count) coins")
                completion(coins)
            } catch {
                print("❌ Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func searchCoins(query: String, completion: @escaping ([CryptoCoin]) -> Void) {
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&ids=\(query)&order=market_cap_desc&per_page=5"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        print("🔍 Searching for: \(query)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
                completion(coins)
            } catch {
                completion([])
            }
        }.resume()
    }
}

// MARK: - Demo Functions
func displayCoin(_ coin: CryptoCoin) {
    print("┌─────────────────────────────────────────┐")
    print("│ \(coin.name.padding(toLength: 25, withPad: " ", startingAt: 0)) │")
    print("│ Symbol: \(coin.symbol.uppercased().padding(toLength: 10, withPad: " ", startingAt: 0))              │")
    print("│ Price: \(coin.formattedPrice.padding(toLength: 15, withPad: " ", startingAt: 0))       │")
    print("│ 24h Change: \(coin.formattedPriceChange.padding(toLength: 12, withPad: " ", startingAt: 0))     │")
    if let rank = coin.marketCapRank {
        print("│ Rank: #\(String(rank).padding(toLength: 10, withPad: " ", startingAt: 0))              │")
    }
    print("└─────────────────────────────────────────┘")
}

func displayWatchInterface() {
    print("""
    ╔═══════════════════════════════════════════╗
    ║            🚀 CRYPTO WATCH 🚀             ║
    ║              Apple Watch App              ║
    ╠═══════════════════════════════════════════╣
    ║                                           ║
    ║  📊 Real-time cryptocurrency tracking     ║
    ║  🔍 Search 17,000+ coins                  ║
    ║  ❤️  Favorites management                  ║
    ║  📱 Optimized for Apple Watch             ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
    """)
}

func simulateWatchInterface() {
    displayWatchInterface()
    
    print("\n🔄 Loading top cryptocurrencies...")
    
    let semaphore = DispatchSemaphore(value: 0)
    
    CryptoService.shared.fetchTopCoins { coins in
        print("\n📊 TOP CRYPTOCURRENCIES")
        print(String(repeating: "═", count: 45))
        
        for (index, coin) in coins.enumerated() {
            print("\n\(index + 1). ", terminator: "")
            displayCoin(coin)
        }
        
        print("\n" + String(repeating: "═", count: 45))
        print("✨ This is how the data would appear on your Apple Watch!")
        print("📱 Features available:")
        print("   • Tap to view detailed coin information")
        print("   • Swipe to add/remove from favorites")
        print("   • Pull to refresh for latest prices")
        print("   • Search for any cryptocurrency")
        
        semaphore.signal()
    }
    
    semaphore.wait()
}

// MARK: - Main Demo
print("🚀 Starting CryptoWatch Apple Watch Demo...")
print("📱 This simulates the crypto tracking app running on Apple Watch")
print("\n" + String(repeating: "─", count: 50))

simulateWatchInterface()

print("\n" + String(repeating: "─", count: 50))
print("🎯 To run the actual Apple Watch app:")
print("   1. Open CryptoWatch.xcodeproj in Xcode")
print("   2. Select Apple Watch simulator")
print("   3. Build and run (⌘+R)")
print("\n✅ Demo completed!") 