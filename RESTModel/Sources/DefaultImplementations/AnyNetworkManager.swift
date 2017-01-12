//
//  AnyNetworkManager.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

public final class AnyNetworkManager <U: ResourceRepresentable> : NetworkManager {

    public typealias T = U

    private let _delete: ((U, @escaping (Result<U>) -> Void) -> Void)
    private let _update: ((U, @escaping (Result<U>) -> Void) -> Void)
    private let _create: ((U, @escaping (Result<U>) -> Void) -> Void)
    private let _retrieve: ((Int, @escaping (Result<U>) -> Void) -> Void)
    private let _retrieveAll: ((@escaping ([U], Error?) -> Void) -> Void)

    public init <Base: NetworkManager>(base b: Base) where Base.T == U {
        _delete = b.delete
        _update = b.update
        _create = b.create
        _retrieve = b.retrieve
        _retrieveAll = b.retrieve
    }

    public func delete(item:T, callback: @escaping (Result<T>) -> Void) {
        _delete(item, callback)
    }

    public func update(item:T, callback: @escaping (Result<T>) -> Void) {
        _update(item, callback)
    }

    public func create(item: T, callback: @escaping (Result<T>) -> Void) {
        _create(item, callback)
    }

    public func retrieve(identifier: Int, callback: @escaping (Result<T>)-> Void) {
        _retrieve(identifier, callback)
    }

    public func retrieve(callback: @escaping ([T], Error?) -> Void) {
        _retrieveAll(callback)
    }
}

extension AnyNetworkManager {

    public convenience init() {
        let defaultManager = URLSessionNetworkManager<U>()
        self.init(base: defaultManager)
    }
}
