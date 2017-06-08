//
//  ConfigurationTests.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/20/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import XCTest

class ConfigurationTests: XCTestCase {
    
    func testDefaultURLSessionPropertiesAreNil() {
        
        /// test that default URLSession properties default to nil
        
        let config = ResourceConfiguration()
        
        XCTAssertNil(config.urlSessionDelegate)
        
        XCTAssertNil(config.urlSessionOperationQueue)        
    }
    
}
