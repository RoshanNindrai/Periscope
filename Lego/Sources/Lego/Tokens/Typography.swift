import SwiftUI

public struct Typography: Equatable, Sendable {
    public let largeTitle = Font.system(.largeTitle, design: .default).weight(.bold)
    public let title = Font.system(.title2, design: .default).weight(.semibold)
    public let subtitle = Font.system(.subheadline, design: .default).weight(.medium)
    public let body = Font.system(.body, design: .default).weight(.regular)
    public let callout = Font.system(.callout, design: .default).weight(.regular)
    public let caption = Font.system(.caption, design: .default).weight(.regular)
    public let button = Font.system(.headline, design: .default).weight(.semibold)
}
