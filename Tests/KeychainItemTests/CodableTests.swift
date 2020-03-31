
import KeychainItem
import Security
import XCTest

final class CodableTests: XCTestCase {

    func testGet() throws {
        let keychain = Keychain(.codable)
        let value = Credentials.random
        let data = try JSONEncoder().encode(value)
        let query = [
            kSecClass as String: kSecClassGenericPassword as AnyObject,
            kSecAttrAccount as String: keychain.item.account as AnyObject,
            kSecValueData as String: data as AnyObject
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            XCTFail("Failed with error: \(status)")
            return
        }
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testGetNil() throws {
        let keychain = Keychain(.codable)
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSet() throws {
        let keychain = Keychain(.codable)
        let value = Credentials.random
        keychain.wrappedValue = value
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testDelete() {
        let keychain = Keychain(.codable)
        let value = Credentials.random
        keychain.wrappedValue = value
        keychain.wrappedValue = nil
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSetAgain() throws {
        let keychain = Keychain(.codable)
        let old = Credentials.random
        keychain.wrappedValue = old
        XCTAssertEqual(keychain.wrappedValue, old)
        let new = Credentials.random
        keychain.wrappedValue = new
        XCTAssertEqual(keychain.wrappedValue, new)
    }

    /// A sanity check to make sure the random credentials are indeed random.
    func testRandomCredentialsAreNotEqual() {
        XCTAssertNotEqual(Credentials.random, Credentials.random)
    }
}

private struct Credentials: Codable, Equatable {
    let username: String
    let password: String

    static var random: Credentials {
        Credentials(username: UUID().uuidString,
                    password: UUID().uuidString)
    }
}

extension KeychainItem where Value == Credentials {

    fileprivate static var codable: KeychainItem {
        KeychainItem(account: UUID().uuidString,
                     accessGroup: nil)
    }
}
