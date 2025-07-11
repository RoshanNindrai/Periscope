import DataModel
import Routes
import Lego
import SwiftUI

public struct HeroBannerView: View {

    // MARK: - Size

    private enum Size {
        static let height: CGFloat = 507
        static let width: CGFloat = height * (2 / 3)
    }

    // MARK: - Properties

    private let items: [any Media]
    private let onSelect: (MediaSelection) -> Void
    private let transitionSourceBuilder: (MediaSelection, AnyView) -> AnyView

    @Environment(\.styleSheet)
    private var styleSheet: StyleSheet

    @State
    private var selectedIndex = 0

    // MARK: - Init

    public init(
        items: [any Media],
        onSelect: @escaping (MediaSelection) -> Void,
        transitionSourceBuilder: @escaping (MediaSelection, AnyView) -> AnyView
    ) {
        self.items = items
        self.onSelect = onSelect
        self.transitionSourceBuilder = transitionSourceBuilder
    }

    // MARK: - Body

    public var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(items.indices, id: \.self) { index in
                bannerTile(for: items[index], index: index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: Size.height)
        .scrollIndicators(.never)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Components

    @ViewBuilder
    private func bannerTile(for media: any Media, index: Int) -> some View {
        let selection = MediaSelection(media: media, key: "Hero-\(media.id)")

        let base = AnyView(
            Button {
                onSelect(selection)
            } label: {
                MediaTileView(media: media, posterSize: .w780)
                    .frame(width: Size.width, height: Size.height)
            }
            .buttonStyle(.plain)
        )

        transitionSourceBuilder(selection, base)
    }
}
