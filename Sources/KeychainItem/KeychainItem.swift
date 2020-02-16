
import Foundation
import Security

public struct KeychainItem<Value> {

    public let account: String
    let decode: (Data) throws -> Value
    let encode: (Value) throws -> Data

    public init(account: String,
                decode: @escaping (Data) throws -> Value,
                encode: @escaping (Value) throws -> Data) {
        self.account = account
        self.decode = decode
        self.encode = encode
    }
}
