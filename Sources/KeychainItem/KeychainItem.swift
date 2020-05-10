
import Foundation
import Security

public struct KeychainItem<Value> {

    public let account: String
    public let accessGroup: AccessGroup?
    let decode: (Data) throws -> Value
    let encode: (Value) throws -> Data

    public init(account: String,
                accessGroup: AccessGroup? = nil,
                decode: @escaping (Data) throws -> Value,
                encode: @escaping (Value) throws -> Data) {
        self.accessGroup = accessGroup
        self.account = account
        self.decode = decode
        self.encode = encode
    }
}

extension KeychainItem {

    public struct AccessGroup: RawRepresentable, Equatable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension KeychainItem.AccessGroup: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
