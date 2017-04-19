//
//  RESTOperationTests.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import XCTest
@testable import Chillax

class RESTOperationTests: XCTestCase {

    var all: [RESTOperation]!

    override func setUp() {
        super.setUp()
        all = [
            .create,
            .retrieve( .single),
            .retrieve( .many),
            .update,
            .delete
        ]
    }
    
    // Note: All of these Unit Tests are testing that `Equality` is implemented correctly.

    func testCreateEquality() {

        let compareAgainst: [RESTOperation] = [.retrieve(.single), .retrieve( .many), .update, .delete]

        compareAgainst.forEach {

            XCTAssertNotEqual(RESTOperation.create, $0)
        }

        XCTAssertEqual(RESTOperation.create, RESTOperation.create)
    }

    func testRetrieveAllEquality() {

        let compareAgainst: [RESTOperation] = [.create, .retrieve(.single), .update, .delete]

        compareAgainst.forEach {

            XCTAssertNotEqual(RESTOperation.retrieve(.many), $0)
        }

        XCTAssertEqual(RESTOperation.retrieve(.many), RESTOperation.retrieve(.many))
    }

    func testRetrieveSingleEquality() {

        let compareAgainst: [RESTOperation] = [.create, .retrieve(.many), .update, .delete]

        compareAgainst.forEach {

            XCTAssertNotEqual(RESTOperation.retrieve(.single), $0)
        }

        XCTAssertEqual(RESTOperation.retrieve(.single), RESTOperation.retrieve(.single))
    }

    func testUpdateEquality() {

        let compareAgainst: [RESTOperation] = [.create, .retrieve(.single), .retrieve(.many), .delete]

        compareAgainst.forEach {

            XCTAssertNotEqual(RESTOperation.update, $0)
        }

        XCTAssertEqual(RESTOperation.update, RESTOperation.update)
    }

    func testDeleteEquality() {

        let compareAgainst: [RESTOperation] = [.create, .retrieve(.single), .retrieve(.many), .update]

        compareAgainst.forEach {

            XCTAssertNotEqual(RESTOperation.delete, $0)
        }

        XCTAssertEqual(RESTOperation.delete, RESTOperation.delete)
    }




}
