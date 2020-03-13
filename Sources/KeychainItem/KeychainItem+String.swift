
import Foundation

extension KeychainItem where Value == String {

    public init(account: String) {

        self.init(account: account,
                  decode: String.decode,
                  encode: String.encode)
    }
}

extension String {

    fileprivate static func encode(string: String) throws -> Data {

        guard let data = string.data(using: .utf8) else {
            struct EncodeError: Error {}
            throw EncodeError()
        }

        return data
    }

    fileprivate static func decode(data: Data) throws -> String {

        guard let string = String(data: data, encoding: .utf8) else {
            struct DecodeError: Error {}
            throw DecodeError()
        }

        return string
    }
}
