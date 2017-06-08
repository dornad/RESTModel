//
//  ChillaxTests.swift
//  ChillaxTests
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import XCTest
@testable import Chillax

class ResourceRepresentableTests: XCTestCase {

    /// Simple test for getting the JSON representation of a Model.
    ///
    ///
    func testJSONRepresentation() {

        let model = Model(identifier: 1)

        let jsonData = try! model.jsonRepresentation(for: CRUDOperation<Model>.create(model: model))
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) else { XCTFail(); return }
        guard let dictionary = jsonObject as? [String: Any] else { XCTFail(); return }

        let identifier = dictionary["id"] as? AnyHashable
        
        XCTAssertEqual(dictionary.count, 1)
        XCTAssertEqual(identifier, model.identifier)
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
}
