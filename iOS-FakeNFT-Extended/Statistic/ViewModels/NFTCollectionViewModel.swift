//
//  NFTCollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 23/02/26.
//
import Foundation

@MainActor
final class NFTCollectionViewModel: ObservableObject {

    enum ScreenState {
        case loading
        case error(String)
        case content([NFTCollectionScreen.NFTItem])
    }

    @Published private(set) var state: ScreenState = .loading

    private let nftIds: [String]
    private let service: NftItemsService

    init(nftIds: [String], service: NftItemsService = NftItemsServiceImpl()) {
        self.nftIds = nftIds
        self.service = service
    }

    func load() async {
        state = .loading

        guard !nftIds.isEmpty else {
            state = .content([])
            return
        }

        do {
            let dtos = try await service.loadNftItems(ids: nftIds)
            let items = dtos.map { dto in
                let url = dto.images.first
                print("🖼 NFT \(dto.id) firstImage=\(url?.absoluteString ?? "nil")")
                return NFTCollectionScreen.NFTItem(
                    id: dto.id,
                    title: dto.name,
                    rating: dto.rating,
                    price: Self.priceString(dto.price),
                    imageURL: url
                )
            }
            state = .content(items)
        } catch let e as NetworkClientError {
            switch e {
            case .httpStatusCode(let code):
                state = .error("Ошибка сервера (\(code))")
            case .parsingError:
                state = .error("Не удалось прочитать данные")
            default:
                state = .error("Не удалось загрузить данные")
            }
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            state = .error("Нет подключения к интернету")
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private static func priceString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.decimalSeparator = "."
        return f.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}
