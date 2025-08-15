
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

2️⃣Open in Xcode

1.Double-click MovieExplorer.xcodeproj or open via Xcode → File → Open.

2.Requires Xcode 15+ and iOS 17+.

3️⃣Get TMDB API Key

1.Sign up at TMDB.

2.Go to your account → API → Request an API key.

3.Replace the apiKey in NetworkManager.swift:

4.private let apiKey = "06840463d3d25f8933cf00a9753e9ae1"

4️⃣Run the app

1.Select your simulator or device in Xcode.

2.Press Cmd + R to build and run.

📡 How Offline Support Works

1.When movies are fetched from the API, they are stored in SwiftData using the Movie model.

2.On app launch or network failure, the app loads movies from the local cache.

3.Refreshing replaces the old cache with the latest movies.

🧠Design Decisions

1.MVVM Architecture was chosen for clear separation of concerns:

   1.Model → SwiftData Movie + API DTO structs

   2.ViewModel → Handles fetching, caching, filtering

   3.View → SwiftUI UI components

2.SwiftData over Core Data for simpler syntax and iOS 17+ integration.

3.Async/Await for cleaner asynchronous API calls.

4.Dependency Injection for ModelContext in MovieListViewModel to make it testable.




