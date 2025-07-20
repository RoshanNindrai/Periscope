import Foundation

public protocol CountryCodeProviderFactory: Sendable {
    func makeCountryCodeProvider() -> CountryCodeProviding
}
