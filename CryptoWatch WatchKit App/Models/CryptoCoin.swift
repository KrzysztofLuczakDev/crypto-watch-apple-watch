import Foundation

struct CryptoCoin: Codable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let marketCapChange24h: Double?
    let marketCapChangePercentage24h: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapChange24h = "market_cap_change_24h"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
    }
    
    // Computed properties for display
    var formattedPrice: String {
        guard let price = currentPrice else { return "N/A" }
        return formatCurrency(price)
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
    
    var formattedMarketCap: String {
        guard let marketCap = marketCap else { return "N/A" }
        return formatLargeNumber(marketCap)
    }
    
    var formattedVolume: String {
        guard let volume = totalVolume else { return "N/A" }
        return formatLargeNumber(volume)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = value < 1 ? 6 : 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    private func formatLargeNumber(_ value: Double) -> String {
        let billion = 1_000_000_000
        let million = 1_000_000
        let thousand = 1_000
        
        if value >= billion {
            return String(format: "$%.2fB", value / Double(billion))
        } else if value >= million {
            return String(format: "$%.2fM", value / Double(million))
        } else if value >= thousand {
            return String(format: "$%.2fK", value / Double(thousand))
        } else {
            return String(format: "$%.2f", value)
        }
    }
}

// Extension for Hashable conformance
extension CryptoCoin {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CryptoCoin, rhs: CryptoCoin) -> Bool {
        return lhs.id == rhs.id
    }
} 