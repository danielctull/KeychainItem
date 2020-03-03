
import Foundation

extension KeychainItem where Value: Codable {

    public init(account: String) {

        self.init(account: account,
                  decode: JSONDecoder().decode,
                  encode: JSONEncoder().encode)
    }
}

extension JSONDecoder {

    fileprivate func decode<Value: Decodable>(from data: Data) throws -> Value {
        try decode(Value.self, from: data)
    }
}
