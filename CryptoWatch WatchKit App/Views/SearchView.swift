import SwiftUI

struct SearchView: View {
    @EnvironmentObject var cryptoService: CryptoService
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, isSearching: $isSearching)
                    .onChange(of: searchText) { newValue in
                        performSearch(query: newValue)
                    }
                
                if cryptoService.isLoading {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if searchText.isEmpty {
                    SearchPlaceholderView()
                } else if cryptoService.searchResults.isEmpty && !searchText.isEmpty {
                    NoResultsView(searchText: searchText)
                } else {
                    List(cryptoService.searchResults) { coin in
                        NavigationLink(destination: CoinDetailView(coin: coin)) {
                            CoinRowView(coin: coin, showFavoriteButton: true)
                        }
                    }
                }
                
                if let errorMessage = cryptoService.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            cryptoService.searchResults = []
            return
        }
        
        // Debounce search to avoid too many API calls
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if searchText == query {
                cryptoService.searchCoins(query: query)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search cryptocurrencies...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onTapGesture {
                        isSearching = true
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            if isSearching {
                Button("Cancel") {
                    text = ""
                    isSearching = false
                    hideKeyboard()
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("Search Cryptocurrencies")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Enter a coin name or symbol to search from over 17,000 cryptocurrencies.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No Results Found")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("No cryptocurrencies found for '\(searchText)'. Try a different search term.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
        .environmentObject(CryptoService.shared)
        .environmentObject(FavoritesManager.shared)
} 