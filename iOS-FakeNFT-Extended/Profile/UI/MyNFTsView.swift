import SwiftUI

struct MyNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: ProfileFavoritesStore
    private let items: [MyNFTItem]
    @AppStorage("my_nfts_sort_option") private var selectedSortRawValue = ""
    @State private var isSortSheetPresented = false
    @State private var screenState: MyNFTsScreenState

    init(
        items: [MyNFTItem] = MyNFTItem.mock,
        screenState: MyNFTsScreenState = .content
    ) {
        self.items = items
        _screenState = State(initialValue: screenState)
    }

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
        .navigationTitle("Мои NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
                    Text("У Вас ещё нет NFT")
                        .font(.system(size: 17, weight: .bold))
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
                                isFavorite: favoritesStore.isFavorite(name: item.name),
                                onLikeTap: { favoritesStore.toggle(name: item.name) }
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
                    .font(.system(size: 31.0 / 2, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)

                Divider()

                HStack(spacing: 0) {
                    Button("Отмена") {
                        screenState = .content
                    }
                    .font(.system(size: 17, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()

                    Button("Повторить") {
                        screenState = .content
                    }
                    .font(.system(size: 17, weight: .semibold))
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
                Text("Сортировка")
                    .font(.system(size: 13, weight: .regular))
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
                            .font(.system(size: 31.0 / 2, weight: .regular))
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
                Text("Закрыть")
                    .font(.system(size: 31.0 / 2, weight: .bold))
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

enum MyNFTsScreenState {
    case loading
    case error(String)
    case content
}

private struct MyNFTRowView: View {
    let item: MyNFTItem
    let isFavorite: Bool
    let onLikeTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            imageBlock

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
                starsView
                Text("от \(item.author)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                Text(item.price)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .lineLimit(1)
            }
            .frame(width: 112, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .frame(height: 140)
    }

    private var imageBlock: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 108, height: 108)
                .overlay {
                    Text(item.name.prefix(1))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                }

            Button(action: onLikeTap) {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(
                        isFavorite
                        ? Color(uiColor: UIColor(hexString: "#F56B6C"))
                        : .white
                    )
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
    }

    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { idx in
                Image(systemName: idx < item.rating ? "star.fill" : "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(idx < item.rating ? Color.yellow : Color(uiColor: UIColor.systemGray5))
            }
        }
    }
}

struct MyNFTItem: Identifiable {
    let id: String
    let name: String
    let rating: Int
    let author: String
    let price: String

    var priceValue: Double {
        let normalized = price
            .replacingOccurrences(of: "ETH", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: " ", with: "")
        return Double(normalized) ?? 0
    }

    static let mock: [MyNFTItem] = [
        MyNFTItem(id: "1", name: "Lilo", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "2", name: "Spring", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "3", name: "April", rating: 3, author: "John Doe", price: "1,78 ETH")
    ]
}

private enum MyNFTSortOption: String, CaseIterable, Identifiable {
    case byPrice
    case byRating
    case byName

    var id: Self { self }

    var title: String {
        switch self {
        case .byPrice:
            return "По цене"
        case .byRating:
            return "По рейтингу"
        case .byName:
            return "По названию"
        }
    }
}

#Preview {
    NavigationStack {
        MyNFTsView()
    }
    .environmentObject(ProfileFavoritesStore())
}

#Preview("Empty") {
    NavigationStack {
        MyNFTsView(items: [])
    }
    .environmentObject(ProfileFavoritesStore())
}

#Preview("Loading") {
    NavigationStack {
        MyNFTsView(screenState: .loading)
    }
    .environmentObject(ProfileFavoritesStore())
}

#Preview("Error") {
    NavigationStack {
        MyNFTsView(screenState: .error("Не удалось загрузить список NFT"))
    }
    .environmentObject(ProfileFavoritesStore())
}
