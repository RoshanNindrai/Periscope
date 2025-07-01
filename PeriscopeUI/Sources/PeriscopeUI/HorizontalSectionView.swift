import DataModel
import Routes
import Lego
import SwiftUI

public struct HorizontalSectionView: View {
    
    enum Size {
        static let height: CGFloat = 156
        static let width: CGFloat = height * (2 / 3)
    }

    private let mediaCategory: MediaCategory

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    @Environment(\.namespace)
    private var namespace: Namespace.ID!

    @Binding
    private var selectedMediaInfo: MediaSelection?

    public init(
        mediaCategory: MediaCategory,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        self.mediaCategory = mediaCategory
        self._selectedMediaInfo = selectedMediaInfo
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            header

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: styleSheet.spacing.spacing100) {
                    ForEach(mediaCategory.mediaItems.indices, id: \.self) { index in
                        mediaTileButton(for: mediaCategory.mediaItems[index], index: index)
                    }
                }
                .padding(.leading, styleSheet.spacing.spacing100)
            }
            .frame(height: Size.height)
        }
        .padding(.vertical, styleSheet.spacing.spacing100)
    }

    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText(mediaCategory.title, style: styleSheet.text(.title))

            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
        .padding(.leading, styleSheet.spacing.spacing100)
    }

    @ViewBuilder
    private func mediaTileButton(for media: any Media, index: Int) -> some View {
        let mediaSelection = MediaSelection(media: media, key: "\(mediaCategory.title)-\(media.id)")

        Button {
            selectedMediaInfo = mediaSelection
        } label: {
            MediaTileView(media: media)
                .buttonStyle(.plain)
        }
        .frame(width: Size.width, height: Size.height)
        .matchedTransitionSource(id: mediaSelection, in: namespace)
    }
}
