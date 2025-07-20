import DataModel
import SwiftUI
import TMDBService
import Lego

/// A horizontally scrolling view that displays available watch providers for a given region.
public struct HWatchProviderView: View {
    
    private let watchRegion: WatchProviderRegion
    private let onSelection: (WatchProvider) -> Void

    /// Injected style sheet for visual consistency.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    /// Injected TMDB image URL builder to generate logo image URLs.
    @Environment(\.tmdbImageURLBuilder)
    private var tmdbImageURLBuilder: TMDBImageURLBuilder
    
    /// Initializes the watch provider view.
    /// - Parameters:
    ///   - watchRegion: Region-specific watch provider data.
    ///   - onSelection: Handler for user selection of a provider.
    public init(watchRegion: WatchProviderRegion, onSelection: @escaping (WatchProvider) -> Void) {
        self.watchRegion = watchRegion
        self.onSelection = onSelection
    }

    public var body: some View {
        if watchRegion.providers.isEmpty {
            // If no providers available, do not render anything.
            EmptyView()
        } else {
            VStack(alignment: .leading) {
                header
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: styleSheet.spacing.spacing100) {
                        // Render each provider as a tap-enabled tile
                        ForEach(watchRegion.providers) { provider in
                            WatchProviderView(provider: provider)
                                .frame(width: 280, height: 76)
                                .background(styleSheet.colors.surface)
                                .cornerRadius(8)
                                .onTapGesture {
                                    onSelection(provider)
                                }
                        }
                    }
                }
            }
        }
    }
    
    /// Header label for the section.
    @ViewBuilder
    private var header: some View {
        LegoText("How To Watch", style: styleSheet.text(.title))
    }
}

/// A single horizontal tile displaying the logo and name of a watch provider.
private struct WatchProviderView: View {
    let provider: WatchProvider

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder

    var body: some View {
        HStack(spacing: styleSheet.spacing.spacing100) {
            logoImage
            LegoText(
                provider.name,
                style: styleSheet.text(.title),
                textModifier: {
                    $0.multilineTextAlignment(.leading)
                      .lineLimit(1)
                }
            )
        }
        .padding(styleSheet.spacing.spacing100)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Renders the provider logo with rounded corners.
    @ViewBuilder
    private var logoImage: some View {
        LegoAsyncImage(
            url: imageURLBuilder.watchProviderImageURL(
                watchProvider: provider,
                size: .w300
            ),
            placeholder: {
                Rectangle().fill(Color.black)
            },
            imageViewBuilder: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        )
        .frame(width: 60, height: 60)
    }
}

#Preview {
    HWatchProviderView(
        watchRegion: WatchProviderRegion(
            countryCode: "US",
            link: "https://www.themoviedb.org/movie/846422-the-old-guard-2/watch?locale=ZA",
            providers: [
                WatchProvider(
                    id: 0,
                    name: "Netflix",
                    logoPath: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg",
                    displayPriority: 0
                ),
                WatchProvider(
                    id: 1,
                    name: "Amazon Prime",
                    logoPath: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg",
                    displayPriority: 1
                ),
                WatchProvider(
                    id: 3,
                    name: "Disney+",
                    logoPath: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg",
                    displayPriority: 2
                )
            ]
        ),
        onSelection: { provider in
            print(provider.name)
        }
    )
}
