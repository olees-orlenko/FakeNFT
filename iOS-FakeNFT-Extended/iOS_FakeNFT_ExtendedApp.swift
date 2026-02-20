import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
                .environmentObject(favoritesManager)
        }
    }
}
