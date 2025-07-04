import DataModel
import Lego
import SwiftUI
import TMDBRepository
import TMDBService

/// DetailView displays media details with parallax effect
public struct DetailFeatureView: View {
    
    // MARK: - Size Constants
    
    enum Size {
        static let height: CGFloat = 506
        static let width: CGFloat = height * (2 / 3)
    }
    
    // MARK: - Properties
    
    private let media: any Media
    private let viewModel: DetailFeatureViewModel
    
    @State
    private var scrollOffset: CGFloat = 0
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    private var spacerHeight: CGFloat { Size.height + 8 }
    
    // MARK: - Init
    
    public init(media: any Media, viewModel: DetailFeatureViewModel) {
        self.media = media
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .top) {
            backdropImage
            
            ScrollView {
                VStack(spacing: styleSheet.spacing.spacing100) {

                    GeometryReader { reader in
                        Color.clear
                            .frame(height: .zero)
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: reader.frame(in: .named("Scroll")).minY
                            )
                    }
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    VStack {
                        titleSection
                        
                        Spacer()
                            .frame(height: spacerHeight)
                    }
                    .background {
                        ZStack {
                            Color.clear.background(.ultraThinMaterial)
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.4)]),
                                startPoint: .top, endPoint: .bottom
                            )
                        }
                    }
                }
            }
            .coordinateSpace(name: "Scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
        .background(.thinMaterial)
        .task(id: media.id) {
            await viewModel.reduce(.loadOtherInformation(mediaId: media.id))
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews and Helpers

private extension DetailFeatureView {
    private var parallaxOffset: CGFloat {
        scrollOffset <= styleSheet.spacing.spacing100 ? scrollOffset * 0.4 : .zero
    }
    
    @ViewBuilder
    var backdropImage: some View {
        LegoAsyncImage(
            url: imageURLBuilder.posterImageURL(
                media: media,
                size: .w780
            ),
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
    
    private func clampScale(for offset: CGFloat) -> CGFloat {
        let scale = 1 + max(0, offset) * 0.004
        return min(scale, 1.2)
    }
    
    @ViewBuilder
    var titleSection: some View {
        VStack(spacing: styleSheet.spacing.spacing100) {
            LegoText(media.title, style: styleSheet.text(.title)) { text in
                text.foregroundColor(styleSheet.colors.textPrimary)
            }
            LegoText(media.overview, style: styleSheet.text(.subtitle)) { text in
                text.multilineTextAlignment(.center)
            }
        }
        .padding(styleSheet.spacing.spacing200)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Scroll Offset Preference Key

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
