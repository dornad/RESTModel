//
//  ChillaxTests.swift
//  ChillaxTests
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import XCTest
@testable import Chillax

class ResourceRepresentableTests: XCTestCase {


    /// Simple test for initializaing a Model from JSON
    ///
    ///
    func testInitializationWithJSONDictionary() {

        let dictionary: JSONDictionary = ["id" : 1]

        guard let model = try? Model(data: dictionary) else { XCTFail(); return }

        XCTAssertNotNil(model)
        XCTAssertEqual(model.identifier, 1)
    }

    /// Simple test for getting the JSON representation of a Model.
    ///
    ///
    func testJSONRepresentation() {

        let model = Model(identifier: 1)

        let dictionary = model.jsonRepresentation(for: .create)

        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(dictionary["id"] as? AnyHashable, model.identifier)
    }

}

extension ResourceRepresentableTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
