
import Foundation

extension KeychainItem where Value: Codable {

    public init(account: String,
                accessGroup: AccessGroup?) {

        self.init(account: account,
                  accessGroup: accessGroup,
                  decode: JSONDecoder().decode,
                  encode: JSONEncoder().encode)
    }
}

extension JSONDecoder {

    fileprivate func decode<Value: Decodable>(from data: Data) throws -> Value {
        try decode(Value.self, from: data)
    }
}
