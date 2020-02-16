
import KeychainItem
import XCTest
import Security

final class KeychainTests: XCTestCase {

    func testGet() throws {
        let keychain = Keychain(.test)
        let value = UUID().uuidString
        let query = [
            kSecClass as String: kSecClassGenericPassword as AnyObject,
            kSecAttrAccount as String: keychain.item.account as AnyObject,
            kSecValueData as String: value.data(using: .utf8)! as AnyObject]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { XCTFail(); return }
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testGetNil() throws {
        let keychain = Keychain(.test)
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSet() throws {
        var keychain = Keychain(.test)
        let value = UUID().uuidString
        keychain.wrappedValue = value
        XCTAssertEqual(keychain.wrappedValue, value)
    }

    func testDelete() {
        var keychain = Keychain(.test)
        let value = UUID().uuidString
        keychain.wrappedValue = value
        keychain.wrappedValue = nil
        XCTAssertNil(keychain.wrappedValue)
    }

    func testSetAgain() throws {
        var keychain = Keychain(.test)
        let old = UUID().uuidString
        keychain.wrappedValue = old
        XCTAssertEqual(keychain.wrappedValue, old)
        let new = UUID().uuidString
        keychain.wrappedValue = new
        XCTAssertEqual(keychain.wrappedValue, new)
    }
}

extension KeychainItem where Value == String {

    static var test: KeychainItem<String> {
        KeychainItem(
            account: UUID().uuidString,
            decode: { String(data: $0, encoding: .utf8)! },
            encode: { $0.data(using: .utf8)! })
    }
}
