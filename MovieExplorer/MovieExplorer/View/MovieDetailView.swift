//
//  MovieDetailView.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: movie.posterURL) { phase in
                    switch phase {
                    case .empty:
                        placeholderImage
                            .frame(height: 300)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)

                    case .failure(_):
                        placeholderImage
                            .frame(height: 300)

                    @unknown default:
                        placeholderImage
                            .frame(height: 300)
                    }
                }
                .frame(maxWidth: .infinity)

                Text(movie.title)
                    .font(.title)
                    .bold()

                HStack {
                    Text("Year:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(movie.releaseFullDate.isEmpty ? "Unknown" : movie.releaseFullDate)
                        .font(.subheadline)
                }

                Text(movie.overview)
                    .font(.body)
                    .padding(.top, 8)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .cornerRadius(12)
    }
}
