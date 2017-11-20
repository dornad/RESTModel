//
//  Model.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

struct Model: Codable, ResourceRepresentable {
    
    static var resourceInformation: ResourceRepresentableConfiguration = ModelResource()
    
    var identifier: AnyHashable
    
    func jsonRepresentation(for operation: ChillaxOperation) throws -> Data {
        let encoder = operation.encoder
        let data = try encoder.encode(self)
        return data
    }
    
}

// MARK: - Codable Implementation

extension Model {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Model.CodingKeys.self)
        guard let intValue = identifier as? Int else {
            throw CodingError.identifierNotInteger
        }
        try container.encode(intValue, forKey: .identifier)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Model.CodingKeys.self)
        let identifier = try container.decode(Int.self, forKey: .identifier)
        self.init(identifier: identifier)
    }
}

extension Model {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
    }
    
    enum CodingError: Error {
        case identifierNotInteger
    }
}
