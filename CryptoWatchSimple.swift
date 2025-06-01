import SwiftUI
import Foundation

// MARK: - Models
struct CryptoCoin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double?
    let priceChangePercentage24h: Double?
    let marketCapRank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
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
    
    var priceChangeColor: Color {
        guard let change = priceChangePercentage24h else { return .gray }
        return change >= 0 ? .green : .red
    }
}

// MARK: - Crypto Service
@MainActor
class CryptoService: ObservableObject {
    @Published var coins: [CryptoCoin] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    func fetchTopCoins() async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fetchedCoins = try JSONDecoder().decode([CryptoCoin].self, from: data)
            coins = fetchedCoins
        } catch {
            errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

// MARK: - Views
struct CoinRowView: View {
    let coin: CryptoCoin
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.formattedPrice)
                    .font(.headline)
                Text(coin.formattedPriceChange)
                    .font(.caption)
                    .foregroundColor(coin.priceChangeColor)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ContentView: View {
    @StateObject private var cryptoService = CryptoService()
    
    var body: some View {
        NavigationView {
            VStack {
                if cryptoService.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = cryptoService.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await cryptoService.fetchTopCoins()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(cryptoService.coins) { coin in
                        CoinRowView(coin: coin)
                    }
                    .refreshable {
                        await cryptoService.fetchTopCoins()
                    }
                }
            }
            .navigationTitle("🚀 Crypto Watch")
            .task {
                await cryptoService.fetchTopCoins()
            }
        }
    }
}

// MARK: - App
@main
struct CryptoWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
} 