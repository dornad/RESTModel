//
//  NetworkUnitTest.swift
//  ChillaxTests
//
//  Created by Daniel Rodriguez on 11/15/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import XCTest
@testable import Chillax

typealias BookOperation = CRUDOperation<Book>

final class NetworkUnitTest: XCTestCase {
    
    func testCreate() {
        
        let exp = expectation(description: "Can create a new model")
        
        let model = Book(id: 2, title: "Fool", author: "Boaty McBoatface", isbn: "abcd1234")
        
        let operation = BookOperation.create(model: model)
        
        let bookService = AnyNetworkService<Book>()
        
        let bookServiceOperation = bookService.perform(operation: operation) { (result) in
            
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 1)
                if !books.isEmpty {
                    let book = books[0]
                    XCTAssertEqual(model, book)
                }
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        bookServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRetrieveAll() {
       
        let exp = expectation(description: "Can retrieve all books")
        
        let operation = BookOperation.retrieveAll
        
        let bookService = AnyNetworkService<Book>()
        
        let bookServiceOperation = bookService.perform(operation: operation) { (result) in
            
            switch result {
            case .success(let books):
                XCTAssertFalse(books.isEmpty, "Should have received at least (1) book")
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        bookServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRetrieveOne() {
        
        let exp = expectation(description: "Can retrieve model by Id")
        
        let operation = BookOperation.retrieveBy(id: 1)
        
        let bookService = AnyNetworkService<Book>()
        
        let bookServiceOperation = bookService.perform(operation: operation) { (result) in
            
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 1)
                if !books.isEmpty {
                    let book = books[0]
                    XCTAssertEqual(book.id, 1)
                    XCTAssertEqual(book.id, book.identifier)
                }
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        bookServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testUpdate() {
        
        let exp = expectation(description: "Can update a model")
        
        let model = Book(id: 2, title: "Fool", author: "Boaty McBoatface", isbn: "abcd1234")
        
        let operation = BookOperation.update(model: model)
        
        let bookService = AnyNetworkService<Book>()
        
        let bookServiceOperation = bookService.perform(operation: operation) { (result) in
            
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 1)
                if !books.isEmpty {
                    let book = books[0]
                    XCTAssertEqual(model, book)
                }
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        bookServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testDelete() {
        
        let exp = expectation(description: "Can remove a model")
        
        let model = Book(id: 2, title: "Fool", author: "Boaty McBoatface", isbn: "abcd1234")
        
        let operation = BookOperation.delete(model: model)
        
        let bookService = AnyNetworkService<Book>()
        
        let bookServiceOperation = bookService.perform(operation: operation) { (result) in
            
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 0)
            case .error(let error):
                XCTFail("Error: \(error)")
            }
            exp.fulfill()
        }
        
        bookServiceOperation.start()
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}


struct Book: Resource {
    
    let id: Int
    let title: String
    let author: String
    let isbn: String
    
    static var resourceInformation: ResourceRepresentableConfiguration = BookResource()
    
    var identifier: AnyHashable {
        return id
    }
    
    func jsonRepresentation(for operation: ChillaxOperation) throws -> Data {
        let encoder = operation.encoder
        let data = try encoder.encode(self)
        return data
    }
}

extension Book {
    
    struct ResourceConfiguration: Configuration {
        var headerFields: [String : String] = ["Content-Type": "application/json"]
        var backgroundSessionSupport: BackgroundSessionSupport = .notSupported
        var sessionProvider: () -> URLSession = { () -> URLSession in
            let urlSessionConfiguration = URLSessionConfiguration.default
            urlSessionConfiguration.protocolClasses?.insert(MockURLProtocol.self, at: 0)
            return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
        }
    }
    
    struct BookResource: ResourceRepresentableConfiguration {
        
        var configuration: Configuration = ResourceConfiguration()
        
        var rootURLComponents: URLComponents {
            var components: URLComponents = URLComponents()
            components.scheme = "http"
            components.port = 8080
            components.host = "mockHost"
            components.path = "/books"
            return components
        }
    }
}

extension Book: Equatable {
    static public func ==(lhs:Book, rhs:Book) -> Bool {
        return lhs.author == rhs.author &&
            lhs.id == rhs.id &&
            lhs.isbn == rhs.isbn &&
            lhs.title == rhs.title
    }
}

class MockURLProtocol: URLProtocol {
    
    var cannedResponse: Data?
    let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    override func startLoading() {
        
        guard let url = request.url else {
            return
        }
        
        if self.request.httpMethod == "GET" {
            if url.absoluteString == "http://mockHost:8080/books" {
                cannedResponse = "[{\"id\": 1, \"title\": \"adam\", \"author\": \"author\", \"isbn\": \"abcd1234\"}, {\"id\": 2, \"title\": \"eve\", \"author\": \"adam\", \"isbn\": \"abcd4321\"}]".data(using: .utf8)
            }
            else if url.absoluteString == "http://mockHost:8080/books/1" {
                cannedResponse = "{\"id\": 1, \"title\": \"adam\", \"author\": \"author\", \"isbn\": \"abcd1234\"}".data(using: .utf8)
            }
            else {
                assertionFailure("unexpected url: \(url.absoluteString)")
            }
        }
        else if self.request.httpMethod == "PUT" {
            if url.absoluteString == "http://mockHost:8080/books/2" {
                cannedResponse = "{\"id\": 2, \"title\": \"Fool\", \"author\": \"Boaty McBoatface\", \"isbn\": \"abcd1234\"}".data(using: .utf8)
            }
            else {
                assertionFailure("unexpected url: \(url.absoluteString)")
            }
        }
        else if self.request.httpMethod == "POST" {
            if url.absoluteString == "http://mockHost:8080/books" {
                cannedResponse = "{\"id\": 2, \"title\": \"Fool\", \"author\": \"Boaty McBoatface\", \"isbn\": \"abcd1234\"}".data(using: .utf8)
            }
            else {
                assertionFailure("unexpected url: \(url.absoluteString)")
            }
        }
        else if self.request.httpMethod == "DELETE" {
            if url.absoluteString == "http://mockHost:8080/books/2" {
                cannedResponse = "{\"id\": 2, \"title\": \"Fool\", \"author\": \"Boaty McBoatface\", \"isbn\": \"abcd1234\"}".data(using: .utf8)
            }
            else {
                assertionFailure("unexpected url: \(url.absoluteString)")
            }
        }
        else {
            assertionFailure("unexpected httpMethod: \(self.request.httpMethod)")
        }

        guard let client = self.client else {
            return
        }
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.2", headerFields: cannedHeaders) else {
            client.urlProtocolDidFinishLoading(self)
            return
        }
        guard let cannedResponse = self.cannedResponse else {
            client.urlProtocolDidFinishLoading(self)
            return
        }
        
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client.urlProtocol(self, didLoad: cannedResponse)
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // NO-OP
    }
    
    override class func canInit(with request:URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
