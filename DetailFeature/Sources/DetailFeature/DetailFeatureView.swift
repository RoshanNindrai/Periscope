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
    
    @Namespace
    private var namespace: Namespace.ID

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
                        
                        switch viewModel.output {
                        case .fetched(let mediaDetailCategory):
                            ForEach(mediaDetailCategory, id: \MediaDetailCategory.id) { detailCategory in
                                switch detailCategory {
                                case .castAndCrew(let castList):
                                    castAndCrew(castList)
                                case .relatedMedia(let mediaList):
                                    relatedMedia(mediaList)
                                case .mediaDetail(let detail):
                                    mediaDetail(detail)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        default:
                            EmptyView()
                        }
                        
                    }
                    .background(styleSheet.colors.background)
                }
            }
        }
        .navigationDestination(isPresented: isPresented) {
            if let selectedMediaInfo = selectedMediaInfo {
                DetailFeatureView(
                    media: selectedMediaInfo.media,
                    viewModel: DetailFeatureViewModel(
                        repository: viewModel.repository
                    )
                )
                .onDisappear {
                    self.selectedMediaInfo = nil
                }
                .navigationTitle(selectedMediaInfo.media.title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTransition(.zoom(sourceID: selectedMediaInfo, in: namespace))
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(styleSheet.colors.background)
        .environment(\.namespace, namespace)
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
    
    func castAndCrew(_ castList: CastList) -> some View {
        CastAndCrewHorizontalSectionView(castList: castList)
    }
    
    func relatedMedia(_ media: MediaList) -> some View {
        VStack {
            HorizontalSectionView(
                mediaDetailCategory: .relatedMedia(media),
                selectedMediaInfo: $selectedMediaInfo
            )
        }
    }
    
    func mediaDetail(_ mediaDetail: any MediaDetail) -> some View {
        MediaDetailInformationView(detail: mediaDetail)
    }
    
    private var isPresented: Binding<Bool> {
        Binding {
            selectedMediaInfo != nil
        } set: { flag in
            if !flag { selectedMediaInfo = nil }
        }
    }
}
