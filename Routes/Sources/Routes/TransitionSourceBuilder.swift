import SwiftUI

public extension View {
    func applyMatchedTransitionSource(
        if matches: Bool,
        id: MediaSelection,
        in namespace: Namespace.ID
    ) -> some View {
        matches
            ? AnyView(self.matchedTransitionSource(id: id, in: namespace))
            : AnyView(self)
    }
}
