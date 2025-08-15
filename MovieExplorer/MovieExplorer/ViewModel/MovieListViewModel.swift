//
//  MovieListViewModel.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import Foundation
import SwiftUI
import SwiftData


@MainActor
final class MovieListViewModel: ObservableObject {
    // UI state
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showError = false

    // Search
    @Published var searchText: String = ""

    // Paging
    @Published var currentPage: Int = 1

    // Derived list for the UI (search filter)
    var filteredMovies: [Movie] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return movies }
        return movies.filter { $0.title.lowercased().contains(query) }
    }

    // SwiftData context
    var modelContext: ModelContext?

    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func loadCachedMovies() {
        guard let modelContext = modelContext else {
            movies = []
            return
        }
        do {
            let fetch = FetchDescriptor<Movie>(sortBy: [SortDescriptor(\.title)])
            movies = try modelContext.fetch(fetch)
        } catch {
            movies = []
            print("Failed to fetch cached movies: \(error)")
        }
    }

    /// Fetch movies for a given page. Page defaults to 1 so calls without args still compile.
    func fetchMoviesFromAPI(page: Int = 1) async {
        guard let modelContext = modelContext else {
            errorMessage = "No database context available."
            showError = true
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let dtos = try await NetworkManager.shared.fetchPopularMovies(page: page)

            if page == 1 {
                // Clear cache for a fresh load
                do {
                    let existingFetch = FetchDescriptor<Movie>()
                    let existingMovies = try modelContext.fetch(existingFetch)
                    existingMovies.forEach { modelContext.delete($0) }
                } catch {
                    print("Could not delete old movies: \(error)")
                }
                // Insert fresh
                for dto in dtos {
                    let m = Movie(id: dto.id,
                                  title: dto.title,
                                  releaseDate: dto.releaseDate,
                                  overview: dto.overview,
                                  posterPath: dto.posterPath)
                    modelContext.insert(m)
                }
            } else {
                // Append results (avoid duplicates)
                let existingIDs = Set(movies.map { $0.id })
                for dto in dtos where !existingIDs.contains(dto.id) {
                    let m = Movie(id: dto.id,
                                  title: dto.title,
                                  releaseDate: dto.releaseDate,
                                  overview: dto.overview,
                                  posterPath: dto.posterPath)
                    modelContext.insert(m)
                }
            }

            try modelContext.save()
            loadCachedMovies()
            currentPage = page
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
            showError = true
            loadCachedMovies() // fallback to cache
        }
    }
}
