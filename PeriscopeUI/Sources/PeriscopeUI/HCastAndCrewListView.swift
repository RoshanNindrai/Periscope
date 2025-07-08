import SwiftUI
import DataModel
import Lego
import TMDBService

/// A horizontal list view that displays cast and crew members with their profile images and roles.
/// It conditionally renders content based on the availability of cast and crew data.
public struct HCastAndCrewListView: View {
    /// The list of cast and crew members to display.
    private let castList: CastAndCrewList
    
    /// The style sheet environment value used for consistent styling throughout the view.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    /// Initializes the view with a given cast and crew list.
    /// - Parameter castList: The model containing cast and crew data to be displayed.
    public init(castList: CastAndCrewList) {
        self.castList = castList
    }
    
    /// The main body of the view. It shows a vertical stack with a header and a horizontally scrolling list of cast and crew tiles.
    /// If there are no cast or crew members, it renders an empty view.
    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            if castList.castAndCrew.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading) {
                    header
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: styleSheet.spacing.spacing300) {
                            ForEach(castList.castAndCrew, id: \.id) { member in
                                EquatableView(content: CastAndCrewTileView(member: member))
                            }
                        }
                        .padding(.leading, styleSheet.spacing.spacing100)
                    }
                    .frame(height: 160)
                }
            }
        }
    }
    
    /// The header view displaying the section title and a chevron icon to indicate navigation.
    @ViewBuilder
    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText("Cast & Crew", style: styleSheet.text(.title))
            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
    }
}

/// A tile view representing an individual cast or crew member.
/// Displays the profile image, name, and role in a vertically stacked layout.
@MainActor
private struct CastAndCrewTileView: View, @MainActor Equatable {
    /// The cast or crew member whose details are displayed.
    let member: any CastAndCrewMember
    
    /// Determines equality between two tile views based on the unique identifier of the cast or crew member.
    /// This is used to optimize view updates by leveraging SwiftUI's EquatableView.
    static func == (lhs: CastAndCrewTileView, rhs: CastAndCrewTileView) -> Bool {
        lhs.member.id == rhs.member.id
    }
    
    /// The style sheet environment value for consistent styling.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet
    
    /// The TMDB image URL builder environment value for constructing image URLs.
    @Environment(\.tmdbImageURLBuilder)
    private var imageURLBuilder: TMDBImageURLBuilder
    
    /// The main layout of the tile, vertically stacking the profile image, name, and role.
    var body: some View {
        VStack(alignment: .center, spacing: styleSheet.spacing.spacing50) {
            profileImage
            LegoText(
                member.name,
                style: styleSheet.text(.caption),
                textModifier: { text in
                    text.lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                }
            )
                
            LegoText(member.role, style: styleSheet.text(.caption))
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(width: 100)
    }
    
    /// Configures the profile image view with asynchronous loading.
    /// Shows a placeholder circle with a person icon while the image loads.
    /// Applies styling such as clipping to a circle and background coloring after loading.
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
        .frame(
            width: 100,
            height: 100
        )
    }
}
