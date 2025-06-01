import SwiftUI

struct TopCoinsView: View {
    @EnvironmentObject var cryptoService: CryptoService
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        NavigationView {
            Group {
                if cryptoService.isLoading && cryptoService.topCoins.isEmpty {
                    ProgressView("Loading top coins...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if cryptoService.topCoins.isEmpty {
                    EmptyTopCoinsView()
                } else {
                    List {
                        ForEach(cryptoService.topCoins) { coin in
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                                CoinRowView(coin: coin, showFavoriteButton: true, showRank: true)
                            }
                        }
                    }
                    .refreshable {
                        await refreshTopCoins()
                    }
                }
            }
            .navigationTitle("Top Coins")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if cryptoService.topCoins.isEmpty {
                    cryptoService.fetchTopCoins()
                }
            }
            
            if let errorMessage = cryptoService.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
        }
    }
    
    @MainActor
    private func refreshTopCoins() async {
        cryptoService.fetchTopCoins()
        // Add a small delay to show the refresh animation
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

struct EmptyTopCoinsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("Unable to Load")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Unable to load top cryptocurrencies. Please check your internet connection and try again.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    TopCoinsView()
        .environmentObject(CryptoService.shared)
        .environmentObject(FavoritesManager.shared)
} 