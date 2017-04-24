//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import XCTest
@testable import Chillax

class URLSessionNetworkServiceTests: XCTestCase {
    
    var service: URLSessionNetworkService<Model>!
    
    typealias ModelOperation = CRUDOperation<Model>
    
    override func setUp() {
        
        super.setUp()
        
        service = URLSessionNetworkService()
        
        service._requestFunction = _requestFunctionMock
    }
    
    func testCreateOperation() {
        
        let createExp = expectation(description: "create operation in networking service")
        
        let model = Model(identifier: 1)
        
        let networkServiceOperation = service.perform(operation: ModelOperation.create(model: model)) { result in
            
            switch result {
                
            case .success(let models):
                XCTAssertNotNil(models)
                
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            
            createExp.fulfill()
        }
        
        networkServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRetrieveOperation() {
        
        let retrieveOneExp = expectation(description: "retrieve operation in networking service")
        
        let networkServiceOperation = service.perform(operation: ModelOperation.retrieveBy(id: 1)) { result in
            
            switch result {
                
            case .success(let models):
                XCTAssertNotNil(models)
                
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            
            retrieveOneExp.fulfill()
        }
        
        networkServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRetrieveAllOperation() {
        
        let retrieveAllExp = expectation(description: "retrieve all operation in networking service")
        
        let networkServiceOperation = service.perform(operation: ModelOperation.retrieveAll) { result in
            
            switch result {
                
            case .success(let models):
                XCTAssertNotNil(models)
                
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            
            retrieveAllExp.fulfill()
        }
        
        networkServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdateOperation() {
        
        let updateExp = expectation(description: "update operation in networking service")
        
        let model = Model(identifier: 1)
        
        let networkServiceOperation = service.perform(operation: ModelOperation.update(model: model)) { result in
            
            switch result {
                
            case .success(let models):
                XCTAssertNotNil(models)
                
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            
            updateExp.fulfill()
        }
        
        networkServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testDeleteOperation() {
        
        let deleteExp = expectation(description: "delete operation in networking service")
        
        let model = Model(identifier: 1)
        
        let networkServiceOperation = service.perform(operation: ModelOperation.delete(model: model)) { result in
            
            switch result {
                
            case .success(let models):
                XCTAssertNotNil(models)
                
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            
            deleteExp.fulfill()
        }
        
        networkServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testCancelOperation() {
        
        let model = Model(identifier: 1)
        
        let op = service.perform(operation: ModelOperation.delete(model: model)) { result in
            // NO-OP
        }
        
        guard var networkServiceOperation = op as? NetworkServiceOperationStub else {
            return
        }
        
        networkServiceOperation.start()
        
        networkServiceOperation.cancel()
        
        XCTAssertTrue(networkServiceOperation.didCancel)        
    }
}

extension URLSessionNetworkServiceTests {
    
    private enum TestError: Error {
        
        case notCRUDOperation
        case mockHttpBodyNil
    }
    
    func _requestFunctionMock(operation: ChillaxOperation, completion: @escaping (HTTPResult) -> Void) -> NetworkServiceOperation {
        
        struct NetworkServiceOperationErroredStub : NetworkServiceOperation {
            func cancel() { } // NO-OP
            func start() { } // NO-OP
            static let instance = NetworkServiceOperationErroredStub()
        }
        
        guard operation is ModelOperation else {
            
            completion( .error(TestError.notCRUDOperation) )
            return NetworkServiceOperationErroredStub.instance
        }
        
        let crudOperation = operation as! ModelOperation
        
        switch crudOperation {
            
        case .create(let model):
            let json = model.jsonRepresentation(for: crudOperation)
            guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                completion( .error(TestError.mockHttpBodyNil) )
                return NetworkServiceOperationErroredStub.instance
            }
            return NetworkServiceOperationStub(completion: completion, result: .success(d))
        
        case .update(let model):
            let json = model.jsonRepresentation(for: crudOperation)
            guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                completion( .error(TestError.mockHttpBodyNil) )
                return NetworkServiceOperationErroredStub.instance
            }
            return NetworkServiceOperationStub(completion: completion, result: .success(d))
        
        case .delete(let model):
            let json = model.jsonRepresentation(for: crudOperation)
            guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                completion( .error(TestError.mockHttpBodyNil) )
                return NetworkServiceOperationErroredStub.instance
            }
            return NetworkServiceOperationStub(completion: completion, result: .success(d))
            
        case .retrieveBy(let id):
            let json: JSONDictionary = ["id" : "\(id)"]
            guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                completion( .error(TestError.mockHttpBodyNil) )
                return NetworkServiceOperationErroredStub.instance
            }
            return NetworkServiceOperationStub(completion: completion, result: .success(d))
        
        case .retrieveAll:
            let json: [JSONDictionary] = [["id" : "1"], ["id" : "2"]]
            guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                completion( .error(TestError.mockHttpBodyNil) )
                return NetworkServiceOperationErroredStub.instance
            }
            return NetworkServiceOperationStub(completion: completion, result: .success(d))
        }
    }
}
