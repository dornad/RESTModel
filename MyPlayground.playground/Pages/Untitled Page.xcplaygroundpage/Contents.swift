//: Playground - noun: a place where people can play

import UIKit
import Chillax
import PlaygroundSupport

//: ## Usage
//:
//: - Run the included server via Vapor.  On the command line:
//:     - vapor build
//:     - vapor run
//:
//: Then call one of these functions:
//: - `retrieveAll()`
//: - `retrieve()`
//: - `create()`
//: - `delete()`

//:  ### Configuration
struct Config: Configuration {
    var headerFields: [String : String] = ["Content-Type": "application/json"]
    var usesBackgroundSession: Bool = false
}

//:  ### Book Resource
struct BookResource: RESTResource {

    var root: URLComponents {
        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.port = 8080
        components.host = "localhost"
        components.path = "/books"
        return components
    }
    
    var configuration: Configuration = Config()
    
    var httpBodyProvider: (JSONDictionary) throws -> Data = { dict -> Data in
        return try JSONSerialization.data(withJSONObject: dict, options: [])
    }

    func path(for operation: RESTOperation) -> URLComponents {
        return path(for: operation, withIdentifier: nil)
    }

    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable? = nil) -> URLComponents {

        var root_ = root

        switch operation {
        case .create:
            break
        case .delete:
            fallthrough
        case .update:
            if let value = identifier {
                root_.path =  root_.path + "/\(value)"
            }
        case .retrieve(let fetchType):
            switch fetchType {
            case .single:
                if let value = identifier {
                    root_.path =  root_.path + "/\(value)"
                }
            case .many:
                break
            }
        }

        return root_
    }
}

//:  ### Book Model

struct Book: ResourceRepresentable {

    static var service = AnyNetworkService<Book>()

    static var resourceInformation: RESTResource = BookResource()

    let identifier: AnyHashable
    let title:String
    let author:String
    let isbn: String

    init(id id_:Int,
         title title_:String,
         author author_:String,
         isbn isbn_:String) {
        identifier = id_
        title = title_
        author = author_
        isbn = isbn_
    }

    init(data: JSONDictionary) throws {
        identifier = data["id"] as? Int ?? 0
        title = data["title"] as? String ?? ""
        author = data["author"] as? String ?? ""
        isbn = data["isbn"] as? String ?? ""
    }

    func jsonRepresentation(for operation: RESTOperation) -> JSONDictionary {

        let dictionary: [String: Any] = [
            "title" : title,
            "author" : author,
            "isbn" : isbn
        ]
        return dictionary
    }

}

//:  ### C.R.U.D. Functions
func retrieveAll() -> NetworkServiceOperation {

    let operation = RESTOperation.retrieve(RetrieveType.many)

    return Book.service.perform(operation: operation) { result in

        switch result {
        case .success (let book):
            print("[✅] books retrieved: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func retrieve() -> NetworkServiceOperation {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    let operation = RESTOperation.retrieve(RetrieveType.single)

    return Book.service.perform(operation: .update, input: book) { result in

        switch result {
        case .success (let book):
            print("[✅] book retrieved: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func create() -> NetworkServiceOperation {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    let task = Book.service.perform(operation: .create, input: book) { result in

        switch result {
        case .success (let book):
            print("[✅] book created: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
    
    return task
}

func update() -> NetworkServiceOperation {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    return Book.service.perform(operation: .update, input: book) { result in

        switch result {
        case .success (let book):
            print("[✅] updated book: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func delete() -> NetworkServiceOperation {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    return Book.service.perform(operation: .delete, input: book) { result in

        switch result {
        case .success (let book):
            print("[✅] book deleted: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

//: Call the functions here

//: This line required for network operations
PlaygroundPage.current.needsIndefiniteExecution = true
