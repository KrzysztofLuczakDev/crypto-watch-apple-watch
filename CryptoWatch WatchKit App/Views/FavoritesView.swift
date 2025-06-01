import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var cryptoService: CryptoService
    @State private var showingEmptyState = false
    
    var body: some View {
        NavigationView {
            Group {
                if favoritesManager.favoriteCoins.isEmpty {
                    EmptyFavoritesView()
                } else {
                    List {
                        ForEach(favoritesManager.favoriteCoins) { coin in
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                                CoinRowView(coin: coin, showFavoriteButton: false)
                            }
                        }
                        .onDelete(perform: deleteFavorite)
                    }
                    .refreshable {
                        await refreshFavorites()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onReceive(cryptoService.$searchResults) { updatedCoins in
            // Update favorites with latest price data
            favoritesManager.updateFavoriteCoins(updatedCoins)
        }
        .onAppear {
            refreshFavoritesData()
        }
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let coin = favoritesManager.favoriteCoins[index]
            favoritesManager.removeFromFavorites(coin)
        }
    }
    
    private func refreshFavoritesData() {
        let favoriteIds = favoritesManager.favoriteCoins.map { $0.id }
        if !favoriteIds.isEmpty {
            cryptoService.updateFavoriteCoins(favoriteIds: favoriteIds)
        }
    }
    
    @MainActor
    private func refreshFavorites() async {
        refreshFavoritesData()
        // Add a small delay to show the refresh animation
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No Favorites Yet")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Search for coins and add them to your favorites to track their prices here.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager.shared)
        .environmentObject(CryptoService.shared)
} 