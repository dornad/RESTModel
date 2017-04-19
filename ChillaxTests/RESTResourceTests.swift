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

    func testItConvertsJSONDictionary() {

        let resource = ModelResource()

        let jsonValue: JSONDictionary = ["id": 1]
        let json = JSON.dictionary(jsonValue)
        guard let data = testData(from: json) else { XCTFail(); return }
        guard let parsedJSON = resource.parse(data: data) else { XCTFail(); return }

        switch parsedJSON {
        case .array(_):
            XCTFail("did not expect an array")
        case .dictionary(let dict):
            XCTAssertTrue(dict == jsonValue)
        }
    }

    func testItConvertsJSONArray() {

        let resource = ModelResource()

        let jsonValue: [JSONDictionary] = [["id": 1], ["id": 2]]
        let json = JSON.array(jsonValue)
        guard let data = testData(from: json) else { XCTFail(); return }
        guard let parsedJSON = resource.parse(data: data) else { XCTFail(); return }

        switch parsedJSON {
        case .array(let array):
            XCTAssertTrue(array == jsonValue)
        case .dictionary(_):
            XCTFail("did not expect a dictionary")
        }
    }

    func testItHandlesNonJSONCorrectly() {

        let notJSON = "Hello World"
        let data = notJSON.data(using: .utf8)!

        let resource = ModelResource()

        let parsedJSON = resource.parse(data: data)

        XCTAssertNil(parsedJSON)
    }

    func testURLRequestFromResource() {

        func httpBodyJSON(request: URLRequest?) -> JSONDictionary? {
            guard let httpBody = request?.httpBody else { return nil }
            let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: [])
            return jsonObject as? JSONDictionary
        }

        let resource = ModelResource()
        let model: Model? = Model(identifier: 1)

        // CREATE

        let createRequest = resource.request(for: .create, fromItem: model)

        XCTAssertEqual(createRequest?.httpMethod, "POST")
        XCTAssertEqual(createRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(httpBodyJSON(request: createRequest), model?.jsonRepresentation(for: .create))

        // RETRIEVE ONE

        let retrieveRequest = resource.request(for: .retrieve(.single), fromItem: model)

        XCTAssertEqual(retrieveRequest?.httpMethod, "GET")
        XCTAssertNil(retrieveRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveRequest?.httpBody)

        // RETRIEVE MANY

        let retrieveManyRequest = resource.request(for: RESTOperation.retrieve(RetrieveType.many))

        XCTAssertEqual(retrieveManyRequest?.httpMethod, "GET")
        XCTAssertNil(retrieveManyRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveManyRequest?.httpBody)

        // UPDATE

        let updateRequest = resource.request(for: .update, fromItem: model)

        XCTAssertEqual(updateRequest?.httpMethod, "PUT")
        XCTAssertEqual(updateRequest?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(httpBodyJSON(request: updateRequest), model?.jsonRepresentation(for: .update))

        // DELETE

        let deleteRequest = resource.request(for: .delete, fromItem: model)

        XCTAssertEqual(deleteRequest?.httpMethod, "DELETE")
        XCTAssertNil(retrieveRequest?.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(retrieveRequest?.httpBody)


        /// SPECIAL CASE

        let updateRequestError = resource.request(for: .update)
        XCTAssertNil(updateRequestError)
    }

}

extension RESTResourceTests {

    fileprivate func testData(from json:JSON) -> Data? {
        switch json {
        case .array(let jsonArray):
            return try? JSONSerialization.data(withJSONObject: jsonArray, options: [])
        case .dictionary(let dict):
            return try? JSONSerialization.data(withJSONObject: dict, options: [])
        }
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
