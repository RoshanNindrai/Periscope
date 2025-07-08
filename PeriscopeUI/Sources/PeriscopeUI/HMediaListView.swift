import DataModel
import Routes
import Lego
import SwiftUI

public struct HMediaListView: View {
    
    enum Size {
        static let height: CGFloat = 180
        static let width: CGFloat = height * (2 / 3)
    }

    private let title: String
    private let mediaItems: [any Media]

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
        title = mediaCategory.title
        mediaItems = mediaCategory.mediaItems
        self._selectedMediaInfo = selectedMediaInfo
    }
    
    public init(
        mediaDetailCategory: MediaDetailCategory,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        title = mediaDetailCategory.title
        mediaItems = mediaDetailCategory.mediaItems ?? []
        self._selectedMediaInfo = selectedMediaInfo
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            if !mediaItems.isEmpty {
                header

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: styleSheet.spacing.spacing100) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            mediaTileButton(for: mediaItems[index], index: index)
                        }
                    }
                }
                .frame(height: Size.height)
            }
        }
    }

    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText(title, style: styleSheet.text(.title))

            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
    }

    @ViewBuilder
    private func mediaTileButton(for media: any Media, index: Int) -> some View {
        let mediaSelection = MediaSelection(media: media, key: "\(title)-\(media.id)")

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
