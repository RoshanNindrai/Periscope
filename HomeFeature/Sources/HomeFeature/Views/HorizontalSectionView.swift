import Routes
import Lego
import SwiftUI
import TMDBRepository

struct HorizontalSectionView: View {
    
    private let movieCategory: MediaCategory
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    private let onSelect: (Media) -> Void
    
    init(
        movieCategory: MediaCategory,
        onSelect: @escaping (Media) -> Void
    ) {
        self.movieCategory = movieCategory
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing50) {
            
            HStack(spacing: styleSheet.spacing.spacing50) {
                LegoText(
                    movieCategory.title, style: styleSheet.text(.title)
                )
                
                Image(
                    systemName: "chevron.right"
                ).font(
                    styleSheet.typography.subtitle
                )
            }
            .padding(.leading, styleSheet.spacing.spacing100)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: styleSheet.spacing.spacing100) {
                    ForEach(Array(movieCategory.mediaList.items.enumerated()), id: \.offset) { rowIndex, movie in
                        Button(action: {
                            onSelect(movie)
                        }) {
                            MediaTileView(
                                movie: movie
                            )
                            .matchedTransitionSource(id: movie.id, in: namespace)
                            .padding(
                                .leading, rowIndex == .zero ? styleSheet.spacing.spacing100 : .zero
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .frame(height: 250)
        }
    }
}

#Preview {
    HorizontalSectionView(
        movieCategory: .popular(
            .init(
                movies: [Media(
                    adult: false,
                    backdropPath: "",
                    genreIds: [],
                    id: 1,
                    originalLanguage: "en",
                    originalTitle: "Title",
                    overview: "Overview...",
                    popularity: 1,
                    posterPath: "",
                    releaseDate: "2025-01-01",
                    title: "Title",
                    video: false,
                    voteAverage: 8.0,
                    voteCount: 100
                )],
                page: 1,
                totalPages: 1,
                totalResults: 1
            )
        ),
        onSelect: { _ in }
    )
}
