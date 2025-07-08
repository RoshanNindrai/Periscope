//
//  MediaTileView.swift
//  
//  A SwiftUI view that displays a media item's poster image with a specified size,
//  providing a placeholder with the title while the image loads.
//

import Lego
import SwiftUI
import DataModel
import TMDBService

/// A view that displays a media poster image tile, using TMDB image URLs and styling.
struct MediaTileView: View {
    /// The media item to display.
    private let media: any Media
    /// The desired size for the poster image.
    private let posterSize: PosterSize

    /// Injected style sheet for consistent styling.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    /// Injected TMDB image URL builder to generate image URLs.
    @Environment(\.tmdbImageURLBuilder)
    private var tmdbImageURLBuilder: TMDBImageURLBuilder

    /// Initializes the view with a media item and an optional poster size (default is w342).
    init(media: any Media, posterSize: PosterSize = .w342) {
        self.media = media
        self.posterSize = posterSize
    }

    /// The view's body showing the media poster or a placeholder with the title.
    var body: some View {
        LegoAsyncImage(
            // The URL for the poster image, constructed via the injected URL builder.
            url: tmdbImageURLBuilder.posterImageURL(media: media, size: posterSize),
            // The placeholder view shown while the image is loading.
            placeholder: {
                ZStack {
                    // Background rectangle matching the style sheet's background color.
                    Rectangle()
                        .fill(styleSheet.colors.background)

                    // Display the media title centered, using caption text style.
                    LegoText(
                        media.title,
                        style: styleSheet.text(.caption)
                    ) { text in
                        text
                            .multilineTextAlignment(.center)
                    }
                    .padding(styleSheet.spacing.spacing200)
                }
            },
            // The image view builder, resizing the image to fit a 2:3 aspect ratio.
            imageViewBuilder: { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
            }
        )
        // Set the background color to the style sheet's background color.
        .background(styleSheet.colors.background)
        // Apply a corner radius for rounded corners as per the style sheet spacing.
        .cornerRadius(styleSheet.spacing.spacing100)
    }
}

/// Preview showing the MediaTileView with sample movie data.
#Preview {
    MediaTileView(
        media: Movie(
            adult: false,
            backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
            genreIds: [28, 12, 878],
            id: 505642,
            originalLanguage: "en",
            originalTitle: "Black Panther: Wakanda Forever",
            overview: "Queen Ramonda, Shuri, M’Baku and the Dora Milaje fight to protect Wakanda from intervening world powers in the wake of King T’Challa’s death.",
            popularity: 1234.56,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75",
            releaseDate: "2022-11-11",
            title: "Black Panther: Wakanda Forever",
            video: false,
            voteAverage: 7.3,
            voteCount: 1892
        )
    ).border(.red)
}
