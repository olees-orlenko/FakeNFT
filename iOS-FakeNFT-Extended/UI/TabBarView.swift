import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        systemImage: "person.crop.circle"
                    )
                }
            CatalogView()
                .tabItem {
                    Label {
                        Text(NSLocalizedString("Tab.catalog", comment: ""))
                    } icon: {
                        Image("Tab Bar Catalog")
                    }
                }
            CartView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.cart", comment: ""),
                        systemImage: "cart"
                    )
                }
            StatisticsFlowView()
                .tabItem {
                    Label {
                        Text(NSLocalizedString("Tab.statistics", comment: ""))
                    } icon: {
                        Image("Tab Bar Statistic")
                    }
                }
        }
    }
}
