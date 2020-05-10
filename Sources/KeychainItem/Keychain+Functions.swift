
import Foundation
import Security

extension Notification.Name {
    static let keychainItemWillChange = Notification.Name(rawValue: "uk.co.danieltull.KeychainItem.keychainItemWillChange")
}

struct KeychainError: Error {
    let status: OSStatus
}

struct NotDataError: Error {}

extension KeychainItem {

    fileprivate var query: [String: AnyObject] {
        var query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account.rawValue as AnyObject
        ]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup.rawValue as AnyObject
        }
        return query
    }
}

extension Keychain {

    static func value(for item: KeychainItem<Value>) throws -> Value? {
        var query = item.query
        query[kSecReturnData as String] = true as AnyObject
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw KeychainError(status: status) }
        guard let data = result as? Data else { throw NotDataError() }
        return try item.decode(data)
    }

    static func setValue(_ value: Value?, for item: KeychainItem<Value>) throws {

        NotificationCenter.default.post(name: .keychainItemWillChange, object: item)

        guard let value = value else {
            try deleteValue(for: item)
            return
        }

        do {
            try addValue(value, for: item)
        } catch {
            try deleteValue(for: item)
            try addValue(value, for: item)
        }
    }

    private static func deleteValue(for item: KeychainItem<Value>) throws {
        let status = SecItemDelete(item.query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }

    private static func addValue(_ value: Value, for item: KeychainItem<Value>) throws {
        let data = try item.encode(value)
        var query = item.query
        query[kSecValueData as String] = data as AnyObject
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError(status: status) }
    }
}
