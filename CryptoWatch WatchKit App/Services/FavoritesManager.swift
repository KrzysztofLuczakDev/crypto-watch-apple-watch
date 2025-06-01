import Foundation
import Combine

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteCoins: [CryptoCoin] = []
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteCoins"
    
    private init() {
        loadFavorites()
    }
    
    func addToFavorites(_ coin: CryptoCoin) {
        if !favoriteCoins.contains(where: { $0.id == coin.id }) {
            favoriteCoins.append(coin)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ coin: CryptoCoin) {
        favoriteCoins.removeAll { $0.id == coin.id }
        saveFavorites()
    }
    
    func isFavorite(_ coin: CryptoCoin) -> Bool {
        return favoriteCoins.contains { $0.id == coin.id }
    }
    
    func updateFavoriteCoin(_ updatedCoin: CryptoCoin) {
        if let index = favoriteCoins.firstIndex(where: { $0.id == updatedCoin.id }) {
            favoriteCoins[index] = updatedCoin
        }
    }
    
    func updateFavoriteCoins(_ updatedCoins: [CryptoCoin]) {
        for updatedCoin in updatedCoins {
            updateFavoriteCoin(updatedCoin)
        }
    }
    
    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoriteCoins)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
    
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: favoritesKey) else { return }
        
        do {
            favoriteCoins = try JSONDecoder().decode([CryptoCoin].self, from: data)
        } catch {
            print("Failed to load favorites: \(error)")
            favoriteCoins = []
        }
    }
} 