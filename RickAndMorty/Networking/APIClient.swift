//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 16/09/2023.
//

import Foundation

// Define a protocol that both the real and mock network clients will conform to
protocol NetworkClientProtocol {
    func get<Response>(_ endpoint: APIClient.Endpoint) async throws -> Response where Response: Decodable
}

struct APIClient {
    enum Request {
        struct Empty: Encodable {}
    }

    struct ResponseErrorMessage: Decodable {
        let error: String
    }

    enum Error: LocalizedError {
        case generic(value: String)
        case `internal`(value: String)

        var errorDescription: String? {
            switch self {
            case .generic(let value):
                return value
            case .internal(let value):
                return "Internal Error: \(value)"
            }
        }
    }

    enum Endpoint {
        case character(page: Int? = nil)
        case location(id: Int)
        case locationByUrlString(_ urlString: String)
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "rickandmortyapi.com"
            switch self {
            case .character(let page):
                components.path = "/api/character"
                if let page = page {
                    components.queryItems = [
                        URLQueryItem(name: "page", value: "\(page)")
                    ]
                }
            case .location(let id):
                components.path = "/api/location"
                components.path = components.path + "/\(id)"
            case .locationByUrlString(let urlString):
                return URL(string: urlString)
            }

            return components.url
        }
    }

    enum Method: String {
        case get
        case post
    }

    class Network: NetworkClientProtocol {
        static let shared = Network()

        fileprivate func fetch<Request, Response>(_ endpoint: APIClient.Endpoint,
                                                  method: APIClient.Method = .get,
                                                  body: Request? = nil) async throws -> Response
            where Request: Encodable, Response: Decodable
        {
            guard let url = endpoint.url else {
                throw APIClient.Error.internal(value: "Invalid URL")
            }
            
            debugPrint(url)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            if let body = body {
                urlRequest.httpBody = try encodeJSONData(data: body)
            }

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse,
                  200 ..< 299 ~= httpResponse.statusCode
            else {
                let error: ResponseErrorMessage = try decodeJSONData(data: data)
                throw APIClient.Error.generic(value: "Invalid Server Response: \(error.error)")
            }

            do {
                let result: Response = try decodeJSONData(data: data)
                return result
            } catch {
                debugPrint(error)
                throw APIClient.Error.generic(value: "Could not fetch data: \(error.localizedDescription)")
            }
        }

        func get<Response>(_ endpoint: APIClient.Endpoint) async throws -> Response where Response: Decodable {
            let body: APIClient.Request.Empty? = nil
            return try await fetch(endpoint, method: .get, body: body)
        }
    }
}

extension APIClient.Network {
    func encodeJSONData(data: Encodable) throws -> Data {
        let decoder = JSONEncoder()
        do {
            let decodedData = try decoder.encode(data)
            return decodedData
        } catch {
            throw APIClient.Error.internal(value: "Could not encode data")
        }
    }

    func decodeJSONData<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIClient.Error.internal(value: "Could not decode data")
        }
    }
}
