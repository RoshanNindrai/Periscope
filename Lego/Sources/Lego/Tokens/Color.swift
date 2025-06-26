import Foundation
import SwiftUI

public struct Color: Equatable, Sendable {
    public let primary = SwiftUI.Color("Primary", bundle: .module)
    public let background = SwiftUI.Color("Background", bundle: .module)
    public let surface = SwiftUI.Color("Surface", bundle: .module)
    public let textPrimary = SwiftUI.Color("TextPrimary", bundle: .module)
    public let textSecondary = SwiftUI.Color("TextSecondary", bundle: .module)
    public let highlight = SwiftUI.Color("Highlight", bundle: .module)
    public let error = SwiftUI.Color("Error", bundle: .module)
}
