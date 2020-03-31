
import KeychainItem
import Security
import XCTest

final class KeychainTests: XCTestCase {

    func testGet() throws {
        let keychain = Keychain(.test)
        let value = UUID().uuidString
        let query = [
            kSecClass as String: kSecClassGenericPassword as AnyObject,
            kSecAttrAccount as String: keychain.item.account as AnyObject,
            kSecValueData as String: try XCTUnwrap(value.data(using: .utf8)) as AnyObject
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            XCTFail("Failed with error: \(status)")
            return
        }
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testGetNil() throws {
        let keychain = Keychain(.test)
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSet() throws {
        let keychain = Keychain(.test)
        let value = UUID().uuidString
        keychain.wrappedValue = value
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testDelete() {
        let keychain = Keychain(.test)
        let value = UUID().uuidString
        keychain.wrappedValue = value
        keychain.wrappedValue = nil
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSetAgain() throws {
        let keychain = Keychain(.test)
        let old = UUID().uuidString
        keychain.wrappedValue = old
        XCTAssertEqual(keychain.wrappedValue, old)
        let new = UUID().uuidString
        keychain.wrappedValue = new
        XCTAssertEqual(keychain.wrappedValue, new)
    }
}

extension KeychainItem where Value == String {

    fileprivate static var test: KeychainItem<String> {
        KeychainItem(
            account: UUID().uuidString,
            accessGroup: nil,
            decode: { try XCTUnwrap(String(data: $0, encoding: .utf8)) },
            encode: { try XCTUnwrap($0.data(using: .utf8)) })
    }
}
