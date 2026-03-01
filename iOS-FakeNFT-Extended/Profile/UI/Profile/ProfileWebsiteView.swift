import SwiftUI

// MARK: - ProfileWebsiteView

struct ProfileWebsiteView: View {
    @Environment(\.dismiss) private var dismiss
    let url: URL

    var body: some View {
        ProfileWebView(url: url)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(uiColor: .closeButton))
                    }
                }
            }
    }
}
