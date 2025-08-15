
# 🎬 MovieExplorer

MovieExplorer is an iOS application built using **Swift**, **SwiftUI**, and **SwiftData** that fetches and displays popular movies from [The Movie Database (TMDB) API](https://developer.themoviedb.org/), with **offline persistence** so users can still view movies without an internet connection.

---

## 📱 Features

- **Popular Movies List**: Fetches movies from TMDB API.
- **Movie Details View**: Displays poster, title, release year, and overview.
- **Offline Support**: Uses SwiftData to cache movies for offline viewing.
- **Search Movies**: Built-in search bar to filter cached movies.
- **Pull to Refresh**: Refresh the list to fetch the latest data.
- **Error Handling**: Displays alerts if API calls fail and falls back to cached data.
- **Pagination Ready**: Supports multiple pages (default: starts from page 1).

---

## 🛠 Tech Stack

- **Language:** Swift 5.10+
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData (`@Model`, `ModelContainer`, `ModelContext`)
- **Networking:** URLSession + async/await
- **Architecture:** MVVM (Model-View-ViewModel)
- **API:** [TMDB Popular Movies API](https://developer.themoviedb.org/reference/movie-popular-list)

---

## 📂 Project Structure

MovieExplorer/
├── Models/
│ ├── Movie.swift # SwiftData model for offline storage
│ ├── MovieDTO.swift # Codable DTO for API mapping
├── Network/
│ └── NetworkManager.swift # Handles API requests
├── ViewModels/
│ └── MovieListViewModel.swift # Fetches and caches movies
├── Views/
│ ├── ContentView.swift # Main movie list view
│ ├── MovieRowView.swift # Row cell for movies
│ ├── MovieDetailView.swift # Detailed movie information
├── MovieExplorerApp.swift # App entry point

Open in Xcode
Double-click MovieExplorer.xcodeproj or open via Xcode → File → Open.

Requires Xcode 15+ and iOS 17+

Get TMDB API Key
Sign up at TMDB.

Go to your account → API → Request an API key.

Replace the apiKey in NetworkManager.swift:

private let apiKey = "06840463d3d25f8933cf00a9753e9ae1"

Run the app
Select your simulator or device in Xcode.

Press Cmd + R to build and run.
ow Offline Support Works
When movies are fetched from the API, they are stored in SwiftData using the Movie model.

On app launch or network failure, the app loads movies from the local cache.

Refreshing replaces the old cache with the latest movies.

Design Decisions
MVVM Architecture was chosen for clear separation of concerns:

Model → SwiftData Movie + API DTO structs

ViewModel → Handles fetching, caching, filtering

View → SwiftUI UI components

SwiftData over Core Data for simpler syntax and iOS 17+ integration.

Async/Await for cleaner asynchronous API calls.

Dependency Injection for ModelContext in MovieListViewModel to make it testable.

