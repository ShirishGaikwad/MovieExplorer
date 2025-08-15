//
//  MovieRowView.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import Foundation
import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    placeholderImage
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 90)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.releaseFullDate) // Year extracted from releaseDate
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 6)
    }
}
private var placeholderImage: some View {
       Image(systemName: "photo")
           .resizable()
           .scaledToFit()
           .foregroundColor(.gray)
           .frame(width: 50, height: 75)
   }

