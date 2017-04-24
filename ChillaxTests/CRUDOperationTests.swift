//
//  RESTOperationTests.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import XCTest
@testable import Chillax

class CRUDOperationTests: XCTestCase {

    var model: Model = Model(identifier: 1)
    
    private typealias ModelOperation = CRUDOperation<Model>
    
    private var all: [ModelOperation]!

    override func setUp() {
        super.setUp()
        
        all = [
            .create(model: model),
            .retrieveBy(id: 1),
            .retrieveAll,
            .update(model: model),
            .delete(model: model)
        ]
    }
    
    // Note: All of these Unit Tests are testing that `Equality` is implemented correctly.

    func testCreateEquality() {

        let compareAgainst: [ModelOperation] = [.retrieveBy(id: 1), .retrieveAll, .update(model: model), .delete(model: model)]

        compareAgainst.forEach {

            XCTAssertNotEqual(ModelOperation.create(model: model), $0)
        }

        XCTAssertEqual(ModelOperation.create(model:model), ModelOperation.create(model:model))
    }

    func testRetrieveAllEquality() {

        let compareAgainst: [ModelOperation] = [.retrieveBy(id: 1), .create(model: model), .update(model: model), .delete(model: model)]
        
        compareAgainst.forEach {
            
            XCTAssertNotEqual(ModelOperation.retrieveAll, $0)
        }
        
        XCTAssertEqual(ModelOperation.retrieveAll, ModelOperation.retrieveAll)
    }

    func testRetrieveSingleEquality() {

        let compareAgainst: [ModelOperation] = [.retrieveAll, .create(model: model), .update(model: model), .delete(model: model)]
        
        compareAgainst.forEach {
            
            XCTAssertNotEqual(ModelOperation.retrieveBy(id: 1), $0)
        }
        
        XCTAssertEqual(ModelOperation.retrieveBy(id: 1), ModelOperation.retrieveBy(id: 1))
    }

    func testUpdateEquality() {

        let compareAgainst: [ModelOperation] = [.retrieveAll, .create(model: model), .retrieveBy(id: 1), .delete(model: model)]
        
        compareAgainst.forEach {
            
            XCTAssertNotEqual(ModelOperation.update(model: model), $0)
        }
        
        XCTAssertEqual(ModelOperation.update(model: model), ModelOperation.update(model: model))
    }

    func testDeleteEquality() {

        let compareAgainst: [ModelOperation] = [.retrieveAll, .create(model: model), .retrieveBy(id: 1), .update(model: model)]
        
        compareAgainst.forEach {
            
            XCTAssertNotEqual(ModelOperation.delete(model: model), $0)
        }
        
        XCTAssertEqual(ModelOperation.delete(model: model), ModelOperation.delete(model: model))
    }




}
