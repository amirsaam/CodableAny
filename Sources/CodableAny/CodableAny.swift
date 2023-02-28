//
//  CodableAny.swift
//
//
//  Created by Amir Mohammadi on 11/13/1401 AP.
//

public struct CodableAny: Codable {
    public let value: Any?
    
    public init<T>(_ value: T?) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = nil
        } else if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(String.self) {
            self.value = value
        } else if let value = try? container.decode([String: CodableAny].self) {
            self.value = value
        } else if let value = try? container.decode([CodableAny].self) {
            self.value = value
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "CodableAny: Value cannot be Decoded!")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self.value {
        case nil:
            try container.encodeNil()
        case let value as Bool:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as String:
            try container.encode(value)
        case let value as [String: CodableAny]:
            try container.encode(value)
        case let value as [CodableAny]:
            try container.encode(value)
        default:
            throw EncodingError.invalidValue(self.value as Any, EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "CodableAny: Value cannot be Encoded!")
            )
        }
    }
}
