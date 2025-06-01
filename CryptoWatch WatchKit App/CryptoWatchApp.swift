import SwiftUI

@main
struct CryptoWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CryptoService.shared)
                .environmentObject(FavoritesManager.shared)
        }
    }
} 