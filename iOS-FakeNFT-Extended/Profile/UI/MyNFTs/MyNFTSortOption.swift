import Foundation

// MARK: - MyNFTSortOption

enum MyNFTSortOption: String, CaseIterable, Identifiable {
    case byPrice
    case byRating
    case byName

    var id: Self { self }

    var title: String {
        switch self {
        case .byPrice:
            return NSLocalizedString("Profile.MyNFTs.sort.price", comment: "")
        case .byRating:
            return NSLocalizedString("Profile.MyNFTs.sort.rating", comment: "")
        case .byName:
            return NSLocalizedString("Profile.MyNFTs.sort.name", comment: "")
        }
    }
}
