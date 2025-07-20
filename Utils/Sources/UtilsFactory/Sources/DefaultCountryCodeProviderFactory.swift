import Utils
import UtilsImpl

public struct DefaultCountryCodeProviderFactory: CountryCodeProviderFactory {
    public init() {}
    
    public func makeCountryCodeProvider() -> CountryCodeProviding {
        return CountryCodeProvider()
    }
}
