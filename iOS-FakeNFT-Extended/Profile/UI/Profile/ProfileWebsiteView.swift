import SwiftUI

// MARK: - ProfileWebsiteView

struct ProfileWebsiteView: View {
    let url: URL

    var body: some View {
        ProfileWebView(url: url)
            .navigationBarTitleDisplayMode(.inline)
    }
}
