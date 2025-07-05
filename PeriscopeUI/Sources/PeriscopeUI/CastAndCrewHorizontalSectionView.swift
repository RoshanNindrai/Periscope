import SwiftUI
import DataModel
import Lego
import TMDBService

public struct CastAndCrewHorizontalSectionView: View {
    private let castList: CastList
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    public init(castList: CastList) {
        self.castList = castList
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            if castList.castAndCrew.isEmpty {
                EmptyView()
            } else {
                header
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: styleSheet.spacing.spacing100) {
                        ForEach(castList.castAndCrew, id: \.id) { member in
                            CastAndCrewTileView(member: member)
                        }
                    }
                    .padding(.leading, styleSheet.spacing.spacing100)
                }
                .frame(height: 160)
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText("Cast & Crew", style: styleSheet.text(.title))
            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
    }
}

private struct CastAndCrewTileView: View {
    let member: any CastAndCrewMember
    
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    var body: some View {
        VStack(alignment: .center, spacing: styleSheet.spacing.spacing50) {
            profileImage
            LegoText(member.name, style: styleSheet.text(.body))
                .lineLimit(1)
                .truncationMode(.tail)
            LegoText(member.role, style: styleSheet.text(.caption))
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(width: 160)
    }
    
    private var profileImage: some View {
        LegoAsyncImage(
            url: imageURLBuilder.profileImageURL(cast: member, size: .w185),
            placeholder: {
                Circle()
                    .fill(styleSheet.colors.surface)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(styleSheet.colors.textSecondary)
                            .font(.system(size: 32))
                    )
            },
            imageViewBuilder: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .background(Circle().fill(styleSheet.colors.background))
            }
        )
        .frame(width: 100, height: 100)
    }
}
