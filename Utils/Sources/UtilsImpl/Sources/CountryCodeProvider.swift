import CoreLocation
import Foundation
import MapKit
import Utils

public final class CountryCodeProvider: NSObject, CountryCodeProviding, @unchecked Sendable {

    private let coreLocation: CLLocationManager
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    public override init() {
        self.coreLocation = CLLocationManager()
        super.init()
        self.coreLocation.delegate = self
    }

    public func requestForPermission() {
        coreLocation.desiredAccuracy = kCLLocationAccuracyReduced
        coreLocation.requestWhenInUseAuthorization()
    }

    public func requestLocationUpdate() {
        coreLocation.requestLocation()
    }

    public func countryCode() async -> String? {
        guard let location = await getLocation() else { return nil }
        return await countryCode(for: location)
    }

    private func getLocation() async -> CLLocation? {
        if let location = coreLocation.location {
            return location
        }

        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            coreLocation.requestLocation()
        }
    }

    private func countryCode(for location: CLLocation) async -> String? {
        let request = MKReverseGeocodingRequest(location: location)
        let mapItem = try? await request?.mapItems.first
        return mapItem?.placemark.isoCountryCode
    }
}

// MARK: - CLLocationManagerDelegate (internal)
extension CountryCodeProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
}
