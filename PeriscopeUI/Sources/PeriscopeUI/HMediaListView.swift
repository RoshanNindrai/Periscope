import DataModel
import Routes
import Lego
import SwiftUI

public struct HMediaListView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let tileHeight: CGFloat = 180
        static let tileWidth: CGFloat = tileHeight * (2 / 3)
    }

    // MARK: - Properties

    private let title: String
    private let mediaItems: [any Media]
    private let onSelect: (MediaSelection) -> Void
    private let transitionSourceBuilder: (MediaSelection, AnyView) -> AnyView

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    // MARK: - Initializers

    public init(
        mediaCategory: MediaCategory,
        onSelect: @escaping (MediaSelection) -> Void,
        transitionSourceBuilder: @escaping (MediaSelection, AnyView) -> AnyView
    ) {
        self.title = mediaCategory.title
        self.mediaItems = mediaCategory.mediaItems
        self.onSelect = onSelect
        self.transitionSourceBuilder = transitionSourceBuilder
    }

    public init(
        mediaDetailCategory: MediaDetailCategory,
        onSelect: @escaping (MediaSelection) -> Void,
        transitionSourceBuilder: @escaping (MediaSelection, AnyView) -> AnyView
    ) {
        self.title = mediaDetailCategory.title
        self.mediaItems = mediaDetailCategory.mediaItems ?? []
        self.onSelect = onSelect
        self.transitionSourceBuilder = transitionSourceBuilder
    }

    // MARK: - Body

    public var body: some View {
        if !mediaItems.isEmpty {
            VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
                header

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: styleSheet.spacing.spacing100) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            mediaTile(for: mediaItems[index], index: index)
                        }
                    }
                }
                .frame(height: Constants.tileHeight)
            }
        }
    }

    // MARK: - Components

    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText(title, style: styleSheet.text(.title))

            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
    }

    @ViewBuilder
    private func mediaTile(for media: any Media, index: Int) -> some View {
        let selection = MediaSelection(media: media, key: "\(title)-\(media.id)")

        let tile = AnyView(
            Button {
                onSelect(selection)
            } label: {
                MediaTileView(media: media)
                    .frame(width: Constants.tileWidth, height: Constants.tileHeight)
            }
            .buttonStyle(.plain)
        )

        transitionSourceBuilder(selection, tile)
    }
}
