import DataModel
import Lego
import SwiftUI

public struct MediaRow: View {
    private let media: any Media

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    public init(media: any Media) {
        self.media = media
    }

    public var body: some View {
        HStack(
            alignment: .top,
            spacing: styleSheet.spacing.spacing100
        ) {
            MediaTileView(media: media)
                .frame(width: 80, height: 120)
                .clipped()

            VStack(
                alignment: .leading,
                spacing: styleSheet.spacing.spacing50
            ) {
                LegoText(media.title, style: styleSheet.text(.body)) { text in
                    text.multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .bold()
                }

                LegoText(
                    media.releaseYear,
                    style: styleSheet.text(.subtitle)
                )

                LegoText(
                    media.type.description,
                    style: styleSheet.text(.callout)
                )
            }

            Spacer(minLength: styleSheet.spacing.spacing100)
        }
        .padding(styleSheet.spacing.spacing100)
        .frame(height: 120)
    }
}

#Preview {
    MediaRow(media: Movie.example)
}
