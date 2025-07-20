/// A utility for securely storing, retrieving, and deleting data in the Keychain on Apple platforms.
/// Supports storing both raw Data and String values, with convenience methods for each.
import Foundation
import Security
import SwiftUI

/// `KeychainStore` provides a simple, thread-safe API for interacting with the Keychain.
/// It allows saving, fetching, and deleting sensitive information securely, identified by a service name and key.
public final class KeychainStore: Sendable {
    /// The service identifier for all keychain entries.
    private let service: String

    /// Creates a new KeychainStore for the specified service.
    /// - Parameter service: A string used to namespace entries (e.g., your app's bundle identifier).
    public init(service: String) {
        self.service = service
    }

    /// Stores data for the given key in the Keychain.
    ///
    /// - Parameters:
    ///   - data: The data to store securely.
    ///   - key: The unique key to associate with the stored data.
    /// - Returns: `true` if the data was saved successfully; otherwise, `false`.
    @discardableResult
    public func set(_ data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
        var attributes = query
        attributes[kSecValueData as String] = data
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Retrieves data for the given key from the Keychain.
    ///
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: The stored data if it exists; otherwise, `nil`.
    public func data(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    /// Deletes data for the given key from the Keychain.
    ///
    /// - Parameter key: The unique key whose associated data should be removed.
    /// - Returns: `true` if the data was deleted successfully; otherwise, `false`.
    @discardableResult
    public func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

// MARK: - String Convenience Helpers

/// Convenience methods for storing and retrieving String values in the Keychain using `KeychainStore`.
public extension KeychainStore {
    /// Stores a UTF-8 encoded string for the given key in the Keychain.
    ///
    /// - Parameters:
    ///   - value: The string value to store.
    ///   - key: The unique key to associate with the value.
    /// - Returns: `true` if the value was saved successfully; otherwise, `false`.
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return set(data, forKey: key)
    }

    /// Retrieves a UTF-8 encoded string for the given key from the Keychain.
    ///
    /// - Parameter key: The unique key associated with the value.
    /// - Returns: The stored string if it exists and is valid UTF-8; otherwise, `nil`.
    func string(forKey key: String) -> String? {
        guard let data = data(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
