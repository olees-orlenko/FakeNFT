import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label {
                        Text(NSLocalizedString("Tab.catalog", comment: ""))
                    } icon: {
                        Image("Tab Bar Catalog")
                    }
                }
                .backgroundStyle(.background)
        }
    }
}
