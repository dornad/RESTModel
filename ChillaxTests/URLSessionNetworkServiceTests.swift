//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import XCTest
@testable import Chillax

class URLSessionNetworkServiceTests: XCTestCase {

    var service: URLSessionNetworkService<Model>!

    override func setUp() {

        super.setUp()

        service = URLSessionNetworkService()

        service._requestFunction = _requestFunctionMock
    }

    func testCreateOperation() {

        let createExp = expectation(description: "create operation in networking service")

        let model = Model(identifier: 1)

        service.perform(operation: .create, input: model) { result in

            switch result {

            case .success(let models):
                XCTAssertNotNil(models)

            case .error(let error):
                XCTFail("Error: \(error)")
            }

            createExp.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testRetrieveOperation() {

        let retrieveOneExp = expectation(description: "retrieve operation in networking service")

        let model = Model(identifier: 1)

        service.perform(operation: .retrieve(.single), input: model) { result in

            switch result {

            case .success(let models):
                XCTAssertNotNil(models)

            case .error(let error):
                XCTFail("Error: \(error)")
            }

            retrieveOneExp.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testRetrieveAllOperation() {

        let retrieveAllExp = expectation(description: "retrieve all operation in networking service")

        service.perform(operation: .retrieve(.many)) { result in

            switch result {

            case .success(let models):
                XCTAssertNotNil(models)

            case .error(let error):
                XCTFail("Error: \(error)")
            }

            retrieveAllExp.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testUpdateOperation() {

        let updateExp = expectation(description: "update operation in networking service")

        let model = Model(identifier: 1)

        service.perform(operation: .update, input: model) { result in

            switch result {

            case .success(let models):
                XCTAssertNotNil(models)

            case .error(let error):
                XCTFail("Error: \(error)")
            }

            updateExp.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testDeleteOperation() {

        let deleteExp = expectation(description: "delete operation in networking service")

        let model = Model(identifier: 1)

        service.perform(operation: .delete, input: model) { result in

            switch result {

            case .success(let models):
                XCTAssertNotNil(models)

            case .error(let error):
                XCTFail("Error: \(error)")
            }

            deleteExp.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

extension URLSessionNetworkServiceTests {

    private enum TestError: Error {

        case testSetup
    }

    func _requestFunctionMock(item: Model?, operation: RESTOperation, completion: @escaping (HTTPResult) -> Void) {

        switch operation {

        case .create:

            guard let json = item?.jsonRepresentation(for: operation) else {
                completion( .error(TestError.testSetup) )
                return
            }
            guard let d = data(from: json) else {
                completion( .error(TestError.testSetup))
                return
            }
            completion( .success(d) )

        case .retrieve( let retrieveType ):

            switch retrieveType {

            case .single:
                let json = ["id": 1]
                guard let d = data(from: json) else {
                    completion( .error(TestError.testSetup))
                    return
                }
                completion( .success(d) )

            case .many:
                let json = [["id": 1], ["id": 2]]
                guard let d = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                    completion( .error(TestError.testSetup))
                    return
                }
                completion( .success(d) )
            }

        case .update:
            guard let json = item?.jsonRepresentation(for: operation) else {
                completion( .error(TestError.testSetup) )
                return
            }
            guard let d = data(from: json) else {
                completion( .error(TestError.testSetup))
                return
            }
            completion( .success(d) )

        case .delete:
            guard let json = item?.jsonRepresentation(for: operation) else {
                completion( .error(TestError.testSetup) )
                return
            }
            guard let d = data(from: json) else {
                completion( .error(TestError.testSetup))
                return
            }
            completion( .success(d) )
        }
    }

    private func data(from json:JSONDictionary) -> Data? {
        return try? JSONSerialization.data(withJSONObject: json, options: [])
    }

}
