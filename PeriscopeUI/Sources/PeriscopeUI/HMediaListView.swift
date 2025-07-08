/// A horizontally-scrolling media list view with selectable media tiles.
import DataModel
import Routes
import Lego
import SwiftUI

public struct HMediaListView: View {
    
    // Constants for tile size
    enum Size {
        static let height: CGFloat = 180
        static let width: CGFloat = height * (2 / 3)
    }

    // Title and media items to be displayed
    private let title: String
    private let mediaItems: [any Media]

    // Styling and namespace from environment
    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    @Environment(\.namespace)
    private var namespace: Namespace.ID!

    // Currently selected media info (binding)
    @Binding
    private var selectedMediaInfo: MediaSelection?

    // Initialize with a MediaCategory
    public init(
        mediaCategory: MediaCategory,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        title = mediaCategory.title
        mediaItems = mediaCategory.mediaItems
        self._selectedMediaInfo = selectedMediaInfo
    }
    
    // Initialize with a MediaDetailCategory
    public init(
        mediaDetailCategory: MediaDetailCategory,
        selectedMediaInfo: Binding<MediaSelection?>
    ) {
        title = mediaDetailCategory.title
        mediaItems = mediaDetailCategory.mediaItems ?? []
        self._selectedMediaInfo = selectedMediaInfo
    }

    // Main view layout
    public var body: some View {
        VStack(alignment: .leading, spacing: styleSheet.spacing.spacing100) {
            if !mediaItems.isEmpty {
                header

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: styleSheet.spacing.spacing100) {
                        ForEach(mediaItems.indices, id: \.self) { index in
                            // Use index as ID for ForEach
                            mediaTileButton(for: mediaItems[index], index: index)
                        }
                    }
                }
                .frame(height: Size.height)
            }
        }
    }

    // Section header with title and chevron
    private var header: some View {
        HStack(spacing: styleSheet.spacing.spacing50) {
            LegoText(title, style: styleSheet.text(.title))

            Image(systemName: "chevron.right")
                .foregroundColor(styleSheet.colors.textSecondary)
                .font(styleSheet.typography.subtitle.weight(.bold))
        }
    }

    // Single media tile button with matched transition and selection logic
    @ViewBuilder
    private func mediaTileButton(for media: any Media, index: Int) -> some View {
        let mediaSelection = MediaSelection(media: media, key: "\(title)-\(media.id)")

        Button {
            // Set selection when tapped
            selectedMediaInfo = mediaSelection
        } label: {
            MediaTileView(media: media)
                .buttonStyle(.plain)
        }
        .frame(width: Size.width, height: Size.height)
        .matchedTransitionSource(id: mediaSelection, in: namespace)
    }
}
