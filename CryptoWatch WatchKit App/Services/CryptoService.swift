import Foundation
import Combine

class CryptoService: ObservableObject {
    static let shared = CryptoService()
    
    @Published var topCoins: [CryptoCoin] = []
    @Published var searchResults: [CryptoCoin] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var priceUpdateTimer: Timer?
    
    private let baseURL = "https://api.coingecko.com/api/v3"
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchTopCoins(limit: Int = 100) {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(limit)&page=1&sparkline=false&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CryptoCoin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Failed to fetch coins: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] coins in
                    self?.topCoins = coins
                }
            )
            .store(in: &cancellables)
    }
    
    func searchCoins(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(baseURL)/search?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid search URL"
                self.isLoading = false
            }
            return
        }
        
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Search failed: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] response in
                    // Convert search results to CryptoCoin objects
                    self?.fetchCoinsDetails(ids: response.coins.prefix(20).map { $0.id })
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchCoinsDetails(ids: [String]) {
        guard !ids.isEmpty else {
            searchResults = []
            return
        }
        
        let idsString = ids.joined(separator: ",")
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&ids=\(idsString)&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid details URL"
            }
            return
        }
        
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CryptoCoin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Failed to fetch coin details: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] coins in
                    self?.searchResults = coins
                }
            )
            .store(in: &cancellables)
    }
    
    func updateFavoriteCoins(favoriteIds: [String]) {
        guard !favoriteIds.isEmpty else { return }
        
        fetchCoinsDetails(ids: favoriteIds)
    }
    
    func startPriceUpdates() {
        stopPriceUpdates()
        
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updatePrices()
        }
    }
    
    func stopPriceUpdates() {
        priceUpdateTimer?.invalidate()
        priceUpdateTimer = nil
    }
    
    private func updatePrices() {
        let favoriteIds = FavoritesManager.shared.favoriteCoins.map { $0.id }
        
        // Update favorites
        if !favoriteIds.isEmpty {
            updateFavoriteCoins(favoriteIds: favoriteIds)
        }
        
        // Update top coins if they're being displayed
        if !topCoins.isEmpty {
            fetchTopCoins(limit: 100)
        }
    }
}

// MARK: - Search Response Models

struct SearchResponse: Codable {
    let coins: [SearchCoin]
}

struct SearchCoin: Codable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String?
    let large: String?
} 