import SwiftUI

struct CoinDetailView: View {
    let coin: CryptoCoin
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(coin.symbol.uppercased())
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(coin.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: toggleFavorite) {
                            Image(systemName: favoritesManager.isFavorite(coin) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesManager.isFavorite(coin) ? .red : .gray)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Price
                    HStack {
                        Text(coin.formattedPrice)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(coin.formattedPriceChange)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(priceChangeColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(priceChangeColor.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Market Data
                VStack(alignment: .leading, spacing: 12) {
                    Text("Market Data")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        if let rank = coin.marketCapRank {
                            DetailRow(title: "Market Cap Rank", value: "#\(rank)")
                        }
                        
                        DetailRow(title: "Market Cap", value: coin.formattedMarketCap)
                        DetailRow(title: "24h Volume", value: coin.formattedVolume)
                        
                        if let high = coin.high24h {
                            DetailRow(title: "24h High", value: formatCurrency(high))
                        }
                        
                        if let low = coin.low24h {
                            DetailRow(title: "24h Low", value: formatCurrency(low))
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Supply Information
                if coin.circulatingSupply != nil || coin.totalSupply != nil || coin.maxSupply != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Supply Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            if let circulating = coin.circulatingSupply {
                                DetailRow(title: "Circulating Supply", value: formatSupply(circulating))
                            }
                            
                            if let total = coin.totalSupply {
                                DetailRow(title: "Total Supply", value: formatSupply(total))
                            }
                            
                            if let max = coin.maxSupply {
                                DetailRow(title: "Max Supply", value: formatSupply(max))
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // All-Time High/Low
                if coin.ath != nil || coin.atl != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All-Time Records")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            if let ath = coin.ath {
                                DetailRow(title: "All-Time High", value: formatCurrency(ath))
                            }
                            
                            if let atl = coin.atl {
                                DetailRow(title: "All-Time Low", value: formatCurrency(atl))
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(coin.symbol.uppercased())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var priceChangeColor: Color {
        guard let change = coin.priceChangePercentage24h else { return .gray }
        return change >= 0 ? .green : .red
    }
    
    private func toggleFavorite() {
        if favoritesManager.isFavorite(coin) {
            favoritesManager.removeFromFavorites(coin)
        } else {
            favoritesManager.addToFavorites(coin)
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = value < 1 ? 6 : 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    private func formatSupply(_ value: Double) -> String {
        let billion = 1_000_000_000
        let million = 1_000_000
        let thousand = 1_000
        
        if value >= billion {
            return String(format: "%.2fB", value / Double(billion))
        } else if value >= million {
            return String(format: "%.2fM", value / Double(million))
        } else if value >= thousand {
            return String(format: "%.2fK", value / Double(thousand))
        } else {
            return String(format: "%.0f", value)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    let sampleCoin = CryptoCoin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: nil,
        currentPrice: 45000.0,
        marketCap: 850000000000,
        marketCapRank: 1,
        fullyDilutedValuation: nil,
        totalVolume: 25000000000,
        high24h: 46000,
        low24h: 44000,
        priceChange24h: 1000,
        priceChangePercentage24h: 2.27,
        marketCapChange24h: nil,
        marketCapChangePercentage24h: nil,
        circulatingSupply: 19500000,
        totalSupply: 19500000,
        maxSupply: 21000000,
        ath: 69000,
        athChangePercentage: -34.78,
        athDate: nil,
        atl: 67.81,
        atlChangePercentage: 66300.45,
        atlDate: nil,
        lastUpdated: nil
    )
    
    return NavigationView {
        CoinDetailView(coin: sampleCoin)
            .environmentObject(FavoritesManager.shared)
    }
} 