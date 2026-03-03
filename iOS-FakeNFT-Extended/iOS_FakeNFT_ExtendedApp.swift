import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesManager)
                .environmentObject(cartManager)
        }
    }
}
