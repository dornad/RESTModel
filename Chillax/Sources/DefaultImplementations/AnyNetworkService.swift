//
//  AnyNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

/// A Type-erased `NetworkService`.
public final class AnyNetworkService <U: Resource> : NetworkService {

    private let _perform: (ChillaxOperation, @escaping (Result<U>) -> Void) -> NetworkServiceOperation    

    public init <B: NetworkService>(base b: B) where B.T == U {        
        _perform = b.perform
    }

    public func perform(operation: ChillaxOperation, callback: @escaping (Result<U>) -> Void) -> NetworkServiceOperation {
        return _perform(operation, callback)
    }
}

extension AnyNetworkService {

    public convenience init() {
        let defaultManager = URLSessionNetworkService<U>()
        self.init(base: defaultManager)
    }
}
