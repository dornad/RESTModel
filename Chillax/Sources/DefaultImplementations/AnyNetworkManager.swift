//
//  AnyNetworkManager.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

/// A Type-erased `NetworkService`.
public final class AnyNetworkService <U: ResourceRepresentable> : NetworkService {

    public typealias T = U

    private let _perform: ((RESTOperation, @escaping (Result<U>) -> Void) -> Void)
    private let _performItem: ((RESTOperation, U, @escaping (Result<U>) -> Void) -> Void)

    public init <Base: NetworkService>(base b: Base) where Base.T == U {
        _perform = b.perform
        _performItem = b.perform
    }

    public func perform(operation: RESTOperation, input: U, callback: @escaping (Result<U>) -> Void) {
        _performItem(operation, input, callback)
    }

    public func perform(operation: RESTOperation, callback: @escaping (Result<U>) -> Void) {
        _perform(operation, callback)
    }
}

extension AnyNetworkService {

    public convenience init() {
        let defaultManager = URLSessionNetworkService<U>()
        self.init(base: defaultManager)
    }
}
