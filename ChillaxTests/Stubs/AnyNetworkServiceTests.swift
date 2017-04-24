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
    
    typealias ModelOperation = CRUDOperation<Model>
    
    func testItWorksAsExpected() {
        
        class NetworkServiceStub: NetworkService {
            
            var didCallPerform = false
            
            func perform(operation: ChillaxOperation, callback: @escaping (Result<Model>) -> Void) -> NetworkServiceOperation {
                didCallPerform = true
                return NetworkServiceOperationStub()
            }
        }
        
        let service = NetworkServiceStub()
        let anyServiceWrapper = AnyNetworkService<Model>(base: service)
        
        let _ = anyServiceWrapper.perform(operation: ModelOperation.retrieveAll) { result in
            // no-op 
        }
        
        XCTAssertTrue(service.didCallPerform)
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

