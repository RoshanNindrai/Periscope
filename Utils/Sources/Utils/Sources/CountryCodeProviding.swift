public protocol CountryCodeProviding: Sendable {
    func requestForPermission()
    func requestLocationUpdate()
    func countryCode() async -> String?
}
