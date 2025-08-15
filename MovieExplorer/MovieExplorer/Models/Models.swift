//
//  Models.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import Foundation

//struct MovieResponseDTO: Codable {
//    let results: [MovieDTO]
//}
//
//struct MovieDTO: Codable {
//    let id: Int
//    let title: String
//    let release_date: String?
//    let overview: String
//    let poster_path: String?
//}
// Models.swift

struct MovieResponseDTO: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let releaseDate: String?
    let overview: String
    let posterPath: String?

//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case releaseDate = "release_date"
//        case overview
//        case posterPath = "poster_path"
//    }

    // Convenience
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var releaseFullDate: String {
        guard let date = releaseDate, !date.isEmpty else { return "N/A" }
        return String(date.prefix(4))
    }
}
