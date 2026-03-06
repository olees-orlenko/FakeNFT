import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case incorrectRequest(String)
}

protocol NetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest) async throws -> T
}

actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func send(request: NetworkRequest) async throws -> Data {
        let urlRequest = try create(request: request)

        print("🌐 [REQUEST] \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "nil")")
        print("🌐 [HEADERS] \(urlRequest.allHTTPHeaderFields ?? [:])")

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let http = response as? HTTPURLResponse else {
                print("❌ [RESPONSE] not HTTPURLResponse")
                throw NetworkClientError.urlSessionError
            }

            print("✅ [RESPONSE] status=\(http.statusCode) url=\(http.url?.absoluteString ?? "nil")")

            if let raw = String(data: data, encoding: .utf8) {
                print("📦 [BODY preview]\n\(String(raw.prefix(500)))")
            }

            guard 200 ..< 300 ~= http.statusCode else {
                throw NetworkClientError.httpStatusCode(http.statusCode)
            }

            return data
        } catch let error as NetworkClientError {
            // важно: не заворачиваем наши ошибки повторно
            print("❌ [NETWORK CLIENT ERROR] \(error)")
            throw error
        } catch {
            print("❌ [URLSession ERROR] \(error)")
            throw NetworkClientError.urlRequestError(error)
        }
    }

    func send<T: Decodable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try await parse(data: data)
    }

    // MARK: - Private

    private func create(request: NetworkRequest) throws -> URLRequest {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if let dto = request.dto,
           let dtoEncoded = try? encoder.encode(dto) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = dtoEncoded
        }
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data) async throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            if let raw = String(data: data, encoding: .utf8) {
                print("❌ [DECODING ERROR] \(T.self)")
                print("📦 [RAW]\n\(String(raw.prefix(800)))")
            }
            throw NetworkClientError.parsingError
        }
    }
}
