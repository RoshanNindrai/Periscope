import Routes
import Lego
import SwiftUI
import TMDBRepository

struct HorizontalSectionView: View {
    
    private let mediaCategory: MediaCategory
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.namespace)
    private var namespace: Namespace.ID!
    
    @Binding
    private var selectedMediaInfo: MediaSelection<Media>?
    
    init(
        mediaCategory: MediaCategory,
        selectedMediaInfo: Binding<MediaSelection<Media>?>
    ) {
        self.mediaCategory = mediaCategory
        self._selectedMediaInfo = selectedMediaInfo
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            
            HStack(spacing: styleSheet.spacing.spacing50) {
                LegoText(
                    mediaCategory.title, style: styleSheet.text(.title)
                )
                
                Image(
                    systemName: "chevron.right"
                ).font(
                    styleSheet.typography.subtitle.weight(.bold)
                )
            }
            .padding(.leading, styleSheet.spacing.spacing100)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: styleSheet.spacing.spacing100) {
                    ForEach(Array(mediaCategory.mediaList.items.enumerated()), id: \.offset) { rowIndex, media in
                        Button(action: {
                            selectedMediaInfo = MediaSelection(
                                media: media,
                                key: "\(mediaCategory.title)-\(media.id)"
                            )
                        }) {
                            MediaTileView(
                                media: media
                            )
                            .padding(
                                .leading, rowIndex == .zero ? styleSheet.spacing.spacing100 : .zero
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                        .matchedTransitionSource(
                            id: MediaSelection(
                                media: media,
                                key: "\(mediaCategory.title)-\(media.id)"
                            ),
                            in: namespace
                        )
                        
                    }
                }
            }
            .frame(height: 250)
        }
        .padding(
            .vertical,
            styleSheet.spacing.spacing100
        )
    }
}

#Preview {
    
    let items = [
        Media(
            adult: false,
            backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
            genreIds: [28, 12, 878],
            id: 505642,
            originalLanguage: "en",
            originalTitle: "Black Panther: Wakanda Forever",
            overview: "Queen Ramonda, Shuri, M’Baku and the Dora Milaje fight to protect Wakanda from intervening world powers in the wake of King T’Challa’s death.",
            popularity: 1234.56,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
            releaseDate: "2022-11-11",
            title: "Black Panther: Wakanda Forever",
            video: false,
            voteAverage: 7.3,
            voteCount: 1892
        ),
        Media(
            adult: false,
            backdropPath: "/xDMIl84Qo5Tsu62c9DGWhmPI67A.jpg",
            genreIds: [28, 12, 878],
            id: 505642,
            originalLanguage: "en",
            originalTitle: "Black Panther: Wakanda Forever",
            overview: "Queen Ramonda, Shuri, M’Baku and the Dora Milaje fight to protect Wakanda from intervening world powers in the wake of King T’Challa’s death.",
            popularity: 1234.56,
            posterPath: "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg",
            releaseDate: "2022-11-11",
            title: "Black Panther: Wakanda Forever",
            video: false,
            voteAverage: 7.3,
            voteCount: 1892
        )
    ]
    
    HorizontalSectionView(
        mediaCategory: .popular(
            .init(
                medias: items,
                page: 1,
                totalPages: 1,
                totalResults: 1
            )
        ),
        selectedMediaInfo: .constant(MediaSelection(media: items.first!, key: ""))
    )
}
