import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
                .environmentObject(favoritesManager)
                .environmentObject(cartManager)
        }
    }
}
