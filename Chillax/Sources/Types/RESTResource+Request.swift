//
//  RESTResource+Request.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

extension RESTResource {

    internal func request(for operation: RESTOperation) -> URLRequest? {
        return _request(for: operation)
    }

    internal func request <T: ResourceRepresentable> (for operation: RESTOperation, fromItem item : T?) -> URLRequest? {
        let itemIdentifier = item?.identifier
        let json = item?.jsonRepresentation(for: operation)
        return _request(for: operation, itemIdentifier: itemIdentifier, json: json)
    }

    private func _request(for operation: RESTOperation, itemIdentifier identifier: AnyHashable? = nil, json: JSONDictionary? = nil) -> URLRequest? {

        guard let url = path(for: operation, withIdentifier: identifier).url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = operation.httpMethod

        switch operation {
        case .retrieve(_):
            break
        case .delete:
            break
        case .create:
            fallthrough
        case .update:
            guard let json = json else { return nil }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        }

        return request
    }

}
