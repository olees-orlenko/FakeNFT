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

            CartView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
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
