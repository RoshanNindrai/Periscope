import Foundation
import SwiftUI

public struct Color: Sendable {
    let primary = SwiftUI.Color("Primary", bundle: .module)
    let background = SwiftUI.Color("Background", bundle: .module)
    let surface = SwiftUI.Color("Surface", bundle: .module)
    let textPrimary = SwiftUI.Color("TextPrimary", bundle: .module)
    let textSecondary = SwiftUI.Color("TextSecondary", bundle: .module)
    let highlight = SwiftUI.Color("Highlight", bundle: .module)
    let error = SwiftUI.Color("Error", bundle: .module)
}
