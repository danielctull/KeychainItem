
import Foundation
import Security

struct KeychainError: Error {
    let status: OSStatus
}

struct NotDataError: Error {}

extension KeychainItem {

    fileprivate var query: [String: AnyObject] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject
        ]
    }
}

enum Keychain {

    static func value<Value>(for item: KeychainItem<Value>) throws -> Value? {
        var query = item.query
        query[kSecReturnData as String] = true as AnyObject
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError(status: status) }
        guard let data = result as? Data else { throw NotDataError() }
        return try item.decode(data)
    }

    static func setValue<Value>(_ value: Value, for item: KeychainItem<Value>) throws {

        do {
            try addValue(value, for: item)
        } catch {
            try deleteValue(for: item)
            try addValue(value, for: item)
        }
    }

    static func deleteValue<Value>(for item: KeychainItem<Value>) throws {
        let status = SecItemDelete(item.query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    static func addValue<Value>(_ value: Value, for item: KeychainItem<Value>) throws {
        let data = try item.encode(value)
        var query = item.query
        query[kSecValueData as String] = data as AnyObject
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
}
