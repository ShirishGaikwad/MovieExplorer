//
//  NetworkManager.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

// NetworkManager.swift
import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
    case timeout
    case unknown(Error)
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Unable to process the data from the server."
        case .httpError(let statusCode):
            return "Server returned an error (code \(statusCode))."
        case .timeout:
            return "The request timed out. Please check your internet connection."
        case .unknown(let err):
            return err.localizedDescription
        }
    }
}
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let apiKey = "06840463d3d25f8933cf00a9753e9ae1"

    func fetchPopularMovies(page: Int) async throws -> [MovieDTO] {
        var comps = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")!
        comps.queryItems = [
            .init(name: "api_key", value: apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: String(page))
        ]
        guard let url = comps.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw NetworkError.httpError(http.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let movieResponse = try decoder.decode(MovieResponseDTO.self, from: data)
                return movieResponse.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch let urlError as URLError {
            if urlError.code == .timedOut { throw NetworkError.timeout }
            throw NetworkError.unknown(urlError)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
