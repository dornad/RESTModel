//
//  AnyRESTResource.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/12/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

/// A Type-Erased RESTResource
public struct AnyRESTResource <Result> : RESTResource {

    private let _path: ((RESTOperation, AnyHashable?) -> Result)
    private let _parseJSON : (Data) -> JSON?

    public static func from<Base: RESTResource>(_ b: Base) -> AnyRESTResource where Base.Result == Result {
        let resource = AnyRESTResource(base: b)
        return resource
    }

    fileprivate init <Base:RESTResource>(base b: Base) where Base.Result == Result {
        _path = b.path
        _parseJSON = b.parse
    }

    func path(for operation: RESTOperation) -> Result {
        return path(for: operation, withIdentifier: nil)
    }

    public func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable?) -> Result {
        return _path(operation, identifier)
    }

    public func parse(data: Data) -> JSON? {
        return _parseJSON(data)
    }
}
