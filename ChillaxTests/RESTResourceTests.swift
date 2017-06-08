//
//  RESTResourceTests.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import XCTest
@testable import Chillax

class RESTResourceTests: XCTestCase {
    
    typealias ModelOperation = CRUDOperation<Model>

    func testURLRequestFromResource() {

        func httpBodyJSON(request: URLRequest?) -> [String: Any]? {
            guard let httpBody = request?.httpBody else { return nil }
            let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: [])
            return jsonObject as? [String: Any]
        }
        
        func json(from data: Data) -> [String: Any]? {
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
            return (jsonObject as? [String: Any])
        }

        let resource = ModelResource()
        let model = Model(identifier: 1)

        // CREATE

        let createRequest = try? resource.request(for: ModelOperation.create(model: model))
        let jsonModelDataCreate = try! model.jsonRepresentation(for: CRUDOperation<Model>.create(model: model))
        let jsonModelCreate = json(from: jsonModelDataCreate)

        XCTAssertEqual(createRequest?.httpMethod, "POST")
        XCTAssertEqual(createRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(httpBodyJSON(request: createRequest), jsonModelCreate)

        // RETRIEVE ONE

        let retrieveRequest = try? resource.request(for: ModelOperation.retrieveBy(id: model.identifier))

        XCTAssertEqual(retrieveRequest?.httpMethod, "GET")
        XCTAssertNil(retrieveRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveRequest?.httpBody)

        // RETRIEVE MANY

        let retrieveManyRequest = try? resource.request(for: ModelOperation.retrieveAll)

        XCTAssertEqual(retrieveManyRequest?.httpMethod, "GET")
        XCTAssertNil(retrieveManyRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveManyRequest?.httpBody)

        // UPDATE

        let updateRequest = try? resource.request(for: ModelOperation.update(model: model))
        let jsonModelData = try! model.jsonRepresentation(for: CRUDOperation<Model>.update(model: model))
        let jsonModel = json(from: jsonModelData)

        XCTAssertEqual(updateRequest?.httpMethod, "PUT")
        XCTAssertEqual(updateRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(httpBodyJSON(request: updateRequest), jsonModel)

        // DELETE

        let deleteRequest = try? resource.request(for: ModelOperation.delete(model: model))

        XCTAssertEqual(deleteRequest?.httpMethod, "DELETE")
        XCTAssertNil(retrieveRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveRequest?.httpBody)
    }

}


extension Dictionary: Equatable  {

    public static func ==(lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Bool {
        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }
}

func == <K, V>(left: [[K:V]], right: [[K:V]]) -> Bool {

    guard left.count == right.count else { return false }

    var result = false

    for leftDict in left {

        var foundMatch = false
        right.forEach { foundMatch = (leftDict == $0) || foundMatch }
        guard foundMatch else { return foundMatch }
        result = foundMatch
    }

    return result
}
