
@testable import KeychainItem
import XCTest
import Security

final class KeychainFunctionTests: XCTestCase {

    func testCopy() throws {
        let item = KeychainItem.test
        let value = UUID().uuidString
        let query = [
            kSecClass as String: kSecClassGenericPassword as AnyObject,
            kSecAttrAccount as String: item.account as AnyObject,
            kSecValueData as String: value.data(using: .utf8)! as AnyObject]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { XCTFail(); return }
        let string = try Keychain.value(for: item)
        XCTAssertEqual(string, value)
    }

    func testCopyNil() throws {
        let item = KeychainItem.test
        let string = try Keychain.value(for: item)
        XCTAssertNil(string)
    }

    func testAdd() throws {
        let item = KeychainItem.test
        let value = UUID().uuidString
        try Keychain.addValue(value, for: item)
        let string = try Keychain.value(for: item)
        XCTAssertEqual(string, value)
    }

    func testAddThrows() throws {
        let item = KeychainItem.test
        let old = UUID().uuidString
        try Keychain.addValue(old, for: item)
        let new = UUID().uuidString
        XCTAssertThrowsError(try Keychain.addValue(new, for: item))
    }

    func testDeleteThrows() {
        XCTAssertThrowsError(try Keychain.deleteValue(for: .test))
    }

    func testSet() throws {
        let item = KeychainItem.test
        let value = UUID().uuidString
        try Keychain.setValue(value, for: item)
        let string = try Keychain.value(for: item)
        XCTAssertEqual(string, value)
    }

    func testSetAgain() throws {
        let item = KeychainItem.test
        let old = UUID().uuidString
        try Keychain.setValue(old, for: item)
        let new = UUID().uuidString
        try Keychain.setValue(new, for: item)
        let string = try Keychain.value(for: item)
        XCTAssertEqual(string, new)
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
