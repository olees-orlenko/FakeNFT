import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }

            CartView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        systemImage: "cart"
                    )
                }
        }
    }
}
