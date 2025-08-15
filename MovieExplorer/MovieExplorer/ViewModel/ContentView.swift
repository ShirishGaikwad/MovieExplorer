//
//  ContentView.swift
//  MovieExplorer
//
//  Created by shirish gayakawad on 12/08/25.
//

import SwiftUI
import SwiftData

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}




struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: MovieListViewModel

    init() {
        _viewModel = StateObject(wrappedValue: MovieListViewModel(modelContext: nil))
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Popular Movies")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewModel.isLoading {
                            ProgressView() // top right activity indicator
                        }
                    }
                }
                .onAppear {
                    if viewModel.modelContext == nil {
                        viewModel.setModelContext(modelContext)
                        viewModel.loadCachedMovies()
                        // First load (page defaults to 1)
                        Task { await viewModel.fetchMoviesFromAPI(page: 1) }
                    }
                }
                .alert(viewModel.errorMessage ?? "", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) {}
                }
                .searchable(text: $viewModel.searchText, prompt: "Search movies")
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            loadingView
        } else if viewModel.filteredMovies.isEmpty {
            emptyView
        } else {
            movieList
        }
    }

    private var loadingView: some View {
        VStack {
            ProgressView("Loading movies...")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyView: some View {
        VStack {
            Text("No movies available.")
                .foregroundColor(.secondary)
            if !viewModel.isLoading {
                Button("Retry") {
                    Task { await viewModel.fetchMoviesFromAPI() } // defaults to page 1
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.filteredMovies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRowView(movie: movie)
                }
            }

            
        }
        .listStyle(.plain)
        .refreshable {
            // Pull-to-refresh reloads from page 1
            await viewModel.fetchMoviesFromAPI(page: 1)
        }
    }
}
