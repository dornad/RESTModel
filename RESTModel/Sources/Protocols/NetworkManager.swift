//
//  NetworkManager.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 1/12/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

public enum Result<T: ResourceRepresentable> {
    case success (T)
    case error (Error)
}

public protocol NetworkManager {

    associatedtype T: ResourceRepresentable

    func delete(item:T, callback: @escaping (Result<T>) -> Void)

    func update(item:T, callback: @escaping (Result<T>) -> Void)

    func create(item: T, callback: @escaping (Result<T>) -> Void)

    func retrieve(identifier: Int, callback: @escaping (Result<T>)-> Void)

    func retrieve(callback: @escaping ([T], Error?) -> Void)
}
