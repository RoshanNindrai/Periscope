import DataModel
import Lego
import Routes
import SwiftUI
import PeriscopeUI
import TMDBRepository
import TMDBService

/// DetailView displays media details with parallax effect
public struct DetailFeatureView: View {

    // MARK: - Constants

    private enum Size {
        static let height: CGFloat = 506
        static let width: CGFloat = height * (2 / 3)
    }

    // MARK: - Properties

    private let media: any Media
    private let viewModel: DetailFeatureViewModel

    @State
    private var scrollOffset: CGFloat = 0
    
    @State
    private var selectedMediaInfo: MediaSelection?

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder

    private var spacerHeight: CGFloat { Size.height + 8 }
    private var parallaxOffset: CGFloat { scrollOffset * 0.4 }

    // MARK: - Init

    public init(media: any Media, viewModel: DetailFeatureViewModel) {
        self.media = media
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .top) {
            backdropImage

            ScrollView(showsIndicators: false) {
                OffsetReader(offset: $scrollOffset)

                VStack(spacing: styleSheet.spacing.spacing100) {
                    Spacer().frame(height: spacerHeight)

                    VStack {
                        titleSection

                        if case .loadedRelatedMovies(let mediaList) = viewModel.state {
                            HorizontalSectionView(
                                mediaCategory: .relatedMovies(mediaList),
                                selectedMediaInfo: $selectedMediaInfo
                            )
                            .padding(.vertical, styleSheet.spacing.spacing200)
                        }
                        
                        
                        
                    }
                    .background(.ultraThinMaterial)
                }
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .task(id: media.id) {
            await viewModel.reduce(.loadOtherInformation(media))
        }
    }
}

// MARK: - Subviews

private extension DetailFeatureView {
    var backdropImage: some View {
        LegoAsyncImage(
            url: imageURLBuilder.posterImageURL(media: media, size: .w780),
            imageViewBuilder: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(clampScale(for: scrollOffset))
                    .drawingGroup()
                    .offset(y: parallaxOffset)
            }
        )
        .frame(height: Size.height)
    }

    func clampScale(for offset: CGFloat) -> CGFloat {
        let scale = 1 + max(0, offset) * 0.004
        return min(scale, 1.2)
    }

    var titleSection: some View {
        VStack(spacing: styleSheet.spacing.spacing100) {
            LegoText(media.title, style: styleSheet.text(.title)) {
                $0.foregroundColor(styleSheet.colors.textPrimary)
            }

            LegoText(media.overview, style: styleSheet.text(.subtitle)) {
                $0.multilineTextAlignment(.center)
            }
        }
        .padding(styleSheet.spacing.spacing200)
        .frame(maxWidth: .infinity)
    }
}
