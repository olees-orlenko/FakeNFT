import SwiftUI

// MARK: - MyNFTsView

struct MyNFTsView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    let items: [MyNFTItem]
    let favoriteIDs: Set<String>
    @Binding var screenState: ScreenState
    let onRetry: () -> Void
    let onLikeTap: (String) -> Void
    @AppStorage("my_nfts_sort_option") private var selectedSortRawValue = ""
    @State private var isSortSheetPresented = false

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            switch screenState {
            case .loading:
                loadingStateView
            case .error(let message):
                ZStack {
                    contentStateView
                    errorStateView(message: message)
                }
            case .content:
                contentStateView
            }

            if isSortSheetPresented, case .content = screenState {
                Color.black
                    .opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isSortSheetPresented = false
                    }

                sortSheet
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSortSheetPresented)
        .navigationTitle(NSLocalizedString("Profile.MyNFTs.title", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                }
            }
            if !items.isEmpty, case .content = screenState {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isSortSheetPresented = true }) {
                        Image("sort")
                            .renderingMode(.template)
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    }
                    .frame(width: 42, height: 42)
                }
            }
        }
    }

    // MARK: - Subviews

    private var sortedItems: [MyNFTItem] {
        guard let selectedSort else { return items }

        switch selectedSort {
        case .byPrice:
            return items.sorted { $0.priceValue > $1.priceValue }
        case .byRating:
            return items.sorted { $0.rating > $1.rating }
        case .byName:
            return items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }

    private var contentStateView: some View {
        Group {
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text(NSLocalizedString("Profile.MyNFTs.empty", comment: ""))
                        .font(Font(UIFont.bodyBold))
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(sortedItems) { item in
                            MyNFTRowView(
                                item: item,
                                isFavorite: favoriteIDs.contains(item.id),
                                onLikeTap: { onLikeTap(item.id) }
                            )
                        }
                    }
                }
            }
        }
    }

    private var loadingStateView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func errorStateView(message: String) -> some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text(message)
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)

                Divider()

                HStack(spacing: 0) {
                    Button(NSLocalizedString("Common.cancel", comment: "")) {
                        screenState = .content
                    }
                    .font(Font(UIFont.bodyRegular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    Button(NSLocalizedString("Common.retry", comment: "")) {
                        onRetry()
                    }
                    .font(Font(UIFont.bodyBold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 44)
            }
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 32)
        }
    }

    private var sortSheet: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Text(NSLocalizedString("Common.sorting", comment: ""))
                    .font(Font(UIFont.caption2))
                    .foregroundStyle(Color(uiColor: UIColor.systemGray))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)

                Divider()

                ForEach(MyNFTSortOption.allCases) { option in
                    Button(action: {
                        selectedSort = option
                        isSortSheetPresented = false
                    }) {
                        Text(option.title)
                            .font(Font(UIFont.bodyRegular))
                            .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                    }
                    .buttonStyle(.plain)

                    if option != MyNFTSortOption.allCases.last {
                        Divider()
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

            Button(action: { isSortSheetPresented = false }) {
                Text(NSLocalizedString("Common.close", comment: ""))
                    .font(Font(UIFont.bodyBold))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .buttonStyle(.plain)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
    }

    private var selectedSort: MyNFTSortOption? {
        get {
            MyNFTSortOption(rawValue: selectedSortRawValue)
        }
        nonmutating set {
            selectedSortRawValue = newValue?.rawValue ?? ""
        }
    }
}

#Preview {
    NavigationStack {
        MyNFTsView(
            items: MyNFTItem.mock,
            favoriteIDs: ["1", "2"],
            screenState: .constant(.content),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Empty") {
    NavigationStack {
        MyNFTsView(
            items: [],
            favoriteIDs: [],
            screenState: .constant(.content),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        MyNFTsView(
            items: [],
            favoriteIDs: [],
            screenState: .constant(.loading),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}

#Preview("Error") {
    NavigationStack {
        MyNFTsView(
            items: MyNFTItem.mock,
            favoriteIDs: [],
            screenState: .constant(.error(NSLocalizedString("Profile.MyNFTs.error", comment: ""))),
            onRetry: {},
            onLikeTap: { _ in }
        )
    }
}
