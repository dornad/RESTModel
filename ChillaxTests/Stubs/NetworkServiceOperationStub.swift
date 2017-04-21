//
//  NetworkServiceOperationStub.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/20/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

internal struct NetworkServiceOperationStub : NetworkServiceOperation {
    
    let _completion: (HTTPResult) -> Void
    let _result : HTTPResult
    
    var didCancel: Bool = false
    
    mutating func cancel() {
        didCancel = true
    }
    
    func start() {
        _completion(_result)
    }
    
    init(completion: @escaping (HTTPResult) -> Void, result: HTTPResult) {
        _completion = completion
        _result = result
    }
    
    init() {
        let resultData = "hello".data(using: .utf8)!
        let completion: (HTTPResult) -> Void = { _ in /* NO-OP */}
        let result = HTTPResult.success(resultData)
        self.init(completion: completion, result: result)
    }
}
