//
//  AnyNetworkServiceTests.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/20/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import XCTest
@testable import Chillax

class AnyNetworkServiceTests: XCTestCase {
    
    func testItWorksAsExpected() {
        
        class NetworkServiceStub: NetworkService {
            
            var didCallPerform = false
            var didCallPerformWithInput = false
            
            func perform(operation: RESTOperation, input: Model, callback: @escaping (Result<Model>) -> Void) -> NetworkServiceOperation {
                didCallPerformWithInput = true
                return NetworkServiceOperationStub()
            }
            
            func perform(operation: RESTOperation, callback: @escaping (Result<Model>) -> Void) -> NetworkServiceOperation {
                didCallPerform = true
                return NetworkServiceOperationStub()
            }
        }
        
        let model = Model(identifier: 1)
        let service = NetworkServiceStub()
        let anyServiceWrapper = AnyNetworkService<Model>(base: service)
        
        let _ = anyServiceWrapper.perform(operation: .retrieve(.many)) { result in }
        
        let _ = anyServiceWrapper.perform(operation: .create, input: model) { result in }
        
        XCTAssertTrue(service.didCallPerform)
        XCTAssertTrue(service.didCallPerformWithInput)
    }
    
    func testInitializesDefaultValuesCorrectly() {
        
        let sut = AnyNetworkService<Model>()        
        XCTAssertNotNil(sut)
    }
    
}

extension AnyNetworkServiceTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

