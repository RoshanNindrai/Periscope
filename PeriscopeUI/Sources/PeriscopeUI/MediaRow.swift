import DataModel
import Lego
import SwiftUI

/// A SwiftUI view that displays a media item's tile image alongside its title, release year, and type in a horizontal row layout.

public struct MediaRow: View {
    /// The media item to display in this row.
    private let media: any Media

    /// The style sheet environment value providing consistent styling and spacing.
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    /// Initializes the MediaRow with a specific media item.
    public init(media: any Media) {
        self.media = media
    }

    /// The main view body containing a horizontal stack with the media tile, details, and spacing.
    public var body: some View {
        HStack(
            alignment: .top,
            spacing: styleSheet.spacing.spacing100
        ) {
            // Displays the media's tile image with fixed size and clipping.
            MediaTileView(media: media)
                .frame(width: 80, height: 120)
                .clipped()

            // Vertical stack containing the title, release year, and type text elements.
            VStack(
                alignment: .leading,
                spacing: styleSheet.spacing.spacing50
            ) {
                // Displays the media title with body style, multiline alignment, limited to 2 lines, and bold font.
                LegoText(media.title, style: styleSheet.text(.body)) { text in
                    text.multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .bold()
                }

                // Displays the media release year with subtitle style.
                LegoText(
                    media.releaseYear,
                    style: styleSheet.text(.subtitle)
                )

                // Displays the media type description with callout style.
                LegoText(
                    media.type.description,
                    style: styleSheet.text(.callout)
                )
            }

            // Adds flexible spacing to push content to the leading edge.
            Spacer(minLength: styleSheet.spacing.spacing100)
        }
        .padding(styleSheet.spacing.spacing100)
        .frame(height: 120)
    }
}

/// #Preview provides a SwiftUI preview of the MediaRow component.
#Preview {
    MediaRow(media: Movie.example)
}
