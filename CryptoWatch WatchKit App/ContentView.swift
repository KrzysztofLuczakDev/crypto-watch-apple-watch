import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cryptoService: CryptoService
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            TopCoinsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Top Coins")
                }
        }
        .onAppear {
            cryptoService.startPriceUpdates()
        }
        .onDisappear {
            cryptoService.stopPriceUpdates()
        }
    }
} 