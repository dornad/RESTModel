//
//  RESTOperation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation


/// The default operations provided by the framework for your models.
///
/// ## Rationale
///
/// These 5 operations are the minimum viable solution for a Create, Retrieve, 
/// Update and Delete (aka CRUD) implementation.
///
/// - seealso: https://en.wikipedia.org/wiki/Create,_read,_update_and_delete
///
/// - create: Persist a model
/// - retrieveBy: Retrieve a model by its identifier (`Hashable`)
/// - retrieveAll: Retrieve all models
/// - update: Update a model
/// - delete: Delete a model
///
public enum CRUDOperation <T: Resource>: ChillaxOperation {
    
    case create(model: T)
    case retrieveBy(id: AnyHashable)
    case retrieveAll
    case update(model: T)
    case delete(model: T)
}


// MARK: ChillaxOperation implementation

extension CRUDOperation {
    
    public var httpMethod: HTTPMethod {
        
        switch self {
        case .create(model: _):
            return .post
        case .retrieveBy(id: _):
            return .get
        case .retrieveAll:
            return .get
        case .update(model: _):
            return .put
        case .delete(model: _):
            return .delete
        }
    }
    
    public var httpHeaderFields: [String:String] {
        
        switch self {
        case .create(model: _):
            return ["Content-Type" : "application/json"]
        case .retrieveBy(id: _):
            return [:]
        case .retrieveAll:
            return [:]
        case .update(model: _):
            return ["Content-Type" : "application/json"]
        case .delete(model: _):
            return [:]
        }
    }
    
    public var urlComponents: URLComponents {
        
        let resource = T.resourceInformation
        
        var components = resource.rootURLComponents

        switch self {
        case .retrieveBy(let id):
            components.path = components.path + "/\(id)"
            return components
        case .update(let model):
            components.path = components.path + "/\(model.identifier)"
            return components
        case .delete(let model):
            components.path = components.path + "/\(model.identifier)"
            return components
        case .retrieveAll:
            return components
        case .create(model: _):
            return components
        }
    }
    
    public var httpBody: Data? {
        
        switch self {
        case .create(let model):
            let encoder = JSONEncoder()
            return try? encoder.encode(model)
        case .retrieveBy(id: _):
            return nil
        case .retrieveAll:
            return nil
        case .update(let model):
            let encoder = JSONEncoder()
            return try? encoder.encode(model)
        case .delete(model: _):
            return nil
        }
    }
    
    public var expectsJSONResponse: Bool {
        
        switch self {
        case .retrieveBy(_):
            return true
        case .update(_):
            return true
        case .delete(_):
            return false
        case .retrieveAll:
            return true
        case .create(model: _):
            return true
        }
    }
}

// MARK: CRUDOperation implementation of Equatable

extension CRUDOperation: Equatable, Hashable {
    
    public var hashValue: Int {
        
        switch self {
        case .create(model: _):
            return 0
        case .retrieveBy(id: _):
            return 1
        case .retrieveAll:
            return 2
        case .update(model: _):
            return 3
        case .delete(model: _):
            return 4
        }
    }
    
    public static func ==(lhs: CRUDOperation<T>, rhs: CRUDOperation<T>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
