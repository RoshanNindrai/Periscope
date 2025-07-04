import DataModel
import Lego
import SwiftUI
import TMDBRepository
import TMDBService

/// DetailView displays media details with parallax effect
public struct DetailView: View {
    
    // MARK: - Size Constants
    
    enum Size {
        static let height: CGFloat = 580
        static let width: CGFloat = height * (2 / 3)
    }
    
    // MARK: - Properties
    
    private let media: any Media
    
    @State
    private var scrollOffset: CGFloat = 0
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    private var spacerHeight: CGFloat { Size.height + 8 }
    
    // MARK: - Init
    
    public init(media: any Media) {
        self.media = media
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .top) {
            backdropImage
            
            ScrollView {
                VStack(spacing: styleSheet.spacing.spacing100) {
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    titleSection
                    
                    Spacer()
                        .frame(height: 900)
                }
                .background(
                    GeometryReader { reader in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: reader.frame(in: .global).minY
                            )
                    }
                )
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Subviews and Helpers

private extension DetailView {
    private var parallaxOffset: CGFloat {
        scrollOffset <= styleSheet.spacing.spacing100 ? scrollOffset * 0.4 : .zero
    }
    
    @ViewBuilder
    var backdropImage: some View {
        LegoAsyncImage(
            url: imageURLBuilder.backdropImageURL(
                media: media,
                size: .w1280
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
        .clipped()
    }
    
    private func clampScale(for offset: CGFloat) -> CGFloat {
        let scale = 1 + max(0, offset) * 0.004
        return min(scale, 1.2)
    }
    
    @ViewBuilder
    var titleSection: some View {
        VStack {
            LegoText(media.title, style: styleSheet.text(.title)) { text in
                text.foregroundColor(styleSheet.colors.textPrimary)
            }
            LegoText(media.releaseDate, style: styleSheet.text(.subtitle)) { text in
                text.foregroundColor(styleSheet.colors.textPrimary)
            }
        }
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

// MARK: - Preview

#Preview {
    DetailView(media: Movie.example)
}
