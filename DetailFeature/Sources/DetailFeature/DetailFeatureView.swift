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
    private var scrollOffset: CGFloat = 0.0
    
    @State
    private var detailViewModel: DetailFeatureViewModel
    
    @State
    private var selectedMediaInfo: MediaSelection?

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    @Namespace
    private var namespace: Namespace.ID

    private var spacerHeight: CGFloat { Size.height + 8 }

    // MARK: - Init

    public init(media: any Media, viewModel: DetailFeatureViewModel) {
        self.media = media
        self.viewModel = viewModel
        self.detailViewModel = DetailFeatureViewModel(repository: viewModel.repository)
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
                        
                        switch viewModel.output {
                        case .fetched(let mediaDetailCategory):
                            ForEach(mediaDetailCategory, id: \MediaDetailCategory.id) { detailCategory in
                                switch detailCategory {
                                case .castAndCrew(let castList):
                                    castAndCrewView(castList)
                                case .relatedMedia(let mediaList):
                                    relatedMediaView(mediaList)
                                case .mediaDetail(let detail):
                                    mediaDetailView(detail)
                                }
                            }
                        case .loading:
                            LegoProgressView(type: .medium)
                        case .failed(let error):
                            LegoText(error.localizedDescription, style: styleSheet.text(.caption))
                        default:
                            EmptyView()
                        }
                        
                    }
                    .background(.black)
                }
            }
        }
        .navigationDestination(item: $selectedMediaInfo) { selectedMediaInfo in
            DetailFeatureView(
                media: selectedMediaInfo.media,
                viewModel: detailViewModel
            )
            .navigationTitle(selectedMediaInfo.media.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTransition(.zoom(sourceID: selectedMediaInfo, in: namespace))
        }
        .ignoresSafeArea(edges: .top)
        .background(.black)
        .environment(\.namespace, namespace)
        .task(id: media.id) {
            await viewModel.reduce(.loadOtherInformation(media))
        }
    }
}

// MARK: - Subviews

private extension DetailFeatureView {
    var backdropImage: some View {
        let parallaxOffset = scrollOffset * 0.4
        let scale = clampScale(for: scrollOffset)
        return LegoAsyncImage(
            url: imageURLBuilder.posterImageURL(media: media, size: .w780),
            placeholder: {
                Rectangle()
                    .fill(styleSheet.colors.background)

            },
            imageViewBuilder: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
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
    
    @ViewBuilder
    func castAndCrewView(_ castList: CastList) -> some View {
        CastAndCrewHorizontalSectionView(castList: castList)
    }
    
    @ViewBuilder
    func relatedMediaView(_ media: MediaList) -> some View {
        VStack {
            HorizontalSectionView(
                mediaDetailCategory: .relatedMedia(media),
                selectedMediaInfo: $selectedMediaInfo
            )
        }
    }
    
    @ViewBuilder
    func mediaDetailView(_ mediaDetail: any MediaDetail) -> some View {
        MediaDetailInformationView(detail: mediaDetail)
    }
}
