import SwiftUI

struct CoinRowView: View {
    let coin: CryptoCoin
    let showFavoriteButton: Bool
    let showRank: Bool
    
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    init(coin: CryptoCoin, showFavoriteButton: Bool = false, showRank: Bool = false) {
        self.coin = coin
        self.showFavoriteButton = showFavoriteButton
        self.showRank = showRank
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Rank (if shown)
            if showRank, let rank = coin.marketCapRank {
                Text("\(rank)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 20, alignment: .leading)
            }
            
            // Coin info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(coin.symbol.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if showFavoriteButton {
                        Button(action: toggleFavorite) {
                            Image(systemName: favoritesManager.isFavorite(coin) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesManager.isFavorite(coin) ? .red : .gray)
                                .font(.caption)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Text(coin.name)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Price info
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.formattedPrice)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(coin.formattedPriceChange)
                    .font(.caption2)
                    .foregroundColor(priceChangeColor)
            }
        }
        .padding(.vertical, 2)
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
        circulatingSupply: nil,
        totalSupply: nil,
        maxSupply: nil,
        ath: nil,
        athChangePercentage: nil,
        athDate: nil,
        atl: nil,
        atlChangePercentage: nil,
        atlDate: nil,
        lastUpdated: nil
    )
    
    return VStack {
        CoinRowView(coin: sampleCoin, showFavoriteButton: true, showRank: true)
        CoinRowView(coin: sampleCoin, showFavoriteButton: false, showRank: false)
    }
    .environmentObject(FavoritesManager.shared)
    .padding()
} 