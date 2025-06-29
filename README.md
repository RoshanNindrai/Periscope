# Periscope

A SwiftUI application for browsing trending, popular, and top-rated movies and TV shows with data powered by the TMDB (The Movie Database) API. Built using modern SwiftUI architecture and a modular feature-based design.

## Features

- Browse trending, popular, upcoming, and top-rated movies and TV shows
- Hero banners and horizontal scrollable sections for media discovery
- Pull-to-refresh and smooth animations
- Modular: easily add new features or sections

## Architecture & Technologies

- **SwiftUI**: Native UI rendering and declarative layout
- **MVVM**: Modular features using ViewModels
- **Swift Concurrency**: Asynchronous data loading
- **Custom UI Components**: `HeroBannerView`, `HorizontalSectionView`, `MediaTileView`, etc.
- **TMDBRepository**: Abstraction for interacting with TMDB endpoints

## Key Modules

- `HomeFeature`: Home screen with sections for each category
- `TMDBRepository`: API interface and data handling
- `Lego`: Shared UI components (e.g., buttons, progress views)
- `Routes`: Navigation and routing helpers

## Getting Started

1. **Clone the repository**

   ```sh
   git clone <repo-url>
   cd <repo-directory>
