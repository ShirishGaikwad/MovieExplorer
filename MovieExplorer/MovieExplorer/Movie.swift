//
//  Movie.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import Foundation
import SwiftData


@Model
class Movie {
    var id: Int
    var title: String
    var releaseDate: String?
    var overview: String
    var posterPath: String?

    init(id: Int, title: String, releaseDate: String?, overview: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
        self.posterPath = posterPath
    }

    var releaseFullDate: String {
        guard let date = releaseDate, !date.isEmpty else { return "N/A" }
        return date
    }


    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
