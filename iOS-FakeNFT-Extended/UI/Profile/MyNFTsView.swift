import SwiftUI

struct MyNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    private let items: [MyNFTItem]

    init(items: [MyNFTItem] = MyNFTItem.mock) {
        self.items = items
    }

    var body: some View {
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
                        ForEach(items) { item in
                            MyNFTRowView(item: item)
                        }
                    }
                }
            }
        }
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
            if !items.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image("sort")
                            .renderingMode(.template)
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    }
                    .frame(width: 42, height: 42)
                }
            }
        }
    }
}

private struct MyNFTRowView: View {
    let item: MyNFTItem

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

            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
                .padding(8)
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

    static let mock: [MyNFTItem] = [
        MyNFTItem(id: "1", name: "Lilo", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "2", name: "Spring", rating: 3, author: "John Doe", price: "1,78 ETH"),
        MyNFTItem(id: "3", name: "April", rating: 3, author: "John Doe", price: "1,78 ETH")
    ]
}

#Preview {
    NavigationStack {
        MyNFTsView()
    }
}

#Preview("Empty") {
    NavigationStack {
        MyNFTsView(items: [])
    }
}
