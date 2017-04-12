//: Playground - noun: a place where people can play

import UIKit
import RESTModel
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

    func path(for operation: RESTOperation) -> URLComponents {
        return path(for: operation, withIdentifier: nil)
    }

    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable? = nil) -> URLComponents {

        var root_ = root

        switch operation {
        case .create:
            fallthrough
        case .getAll:
            fallthrough
        case .delete:
            fallthrough
        case .get:
            fallthrough
        case .update:
            if let value = identifier {
                root_.path =  root_.path + "/\(value)"
            }
        }

        return root_
    }
}

//:  ### Book Model

struct Book: ResourceRepresentable {

    static var service = AnyNetworkService<Book>()

    static var resourceInformation = AnyRESTResource.from( BookResource() )

    let identifier: Int
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

    init(data: JSON) throws {
        identifier = data.dictionary?["id"] as? Int ?? 0
        title = data.dictionary?["title"] as? String ?? ""
        author = data.dictionary?["author"] as? String ?? ""
        isbn = data.dictionary?["isbn"] as? String ?? ""
    }

    func jsonRepresentation(for operation: RESTOperation) -> JSON {

        let dictionary: [String: Any] = [
            "title" : title,
            "author" : author,
            "isbn" : isbn
        ]
        return JSON(dictionary: dictionary)
    }
}

//:  ### C.R.U.D. Functions

func retrieveAll() {

    Book.service.retrieve { (books:[Book], error: Error?) in

        if let err = error {
            print("[❌] Error: \(err)")
        }
        else {
            print("[✅] fetched books: \(books)")
        }
    }
}

func retrieve() {

    Book.service.retrieve(identifier: 1) { (result) in

        switch result {
        case .success (let book):
            print("[✅] book retrieved: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func create() {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    Book.service.create(item: book) { (result) in

        switch result {
        case .success (let book):
            print("[✅] book created: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func update() {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    Book.service.update(item: book) { (result) in

        switch result {
        case .success (let book):
            print("[✅] updated book: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

func delete() {

    let book = Book(id: 1, title: "The impossible Foo", author: "Baz", isbn: "abcd1234")

    Book.service.delete(item: book) { (result) in

        switch result {
        case .success (let book):
            print("[✅] book deleted: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

//: Call the functions here

delete()

//: This line required for network operations

PlaygroundPage.current.needsIndefiniteExecution = true