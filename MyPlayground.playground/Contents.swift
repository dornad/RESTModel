//: Playground - noun: a place where people can play

import UIKit
import RESTModel
import PlaygroundSupport

struct BookResource: RESTResource {

    static let root = "http://localhost:8080/"

    func path(forOperation operation: RESTOperation) -> String {
        return path(forOperation: operation, value: nil)
    }

    func path(forOperation operation: RESTOperation, value: Int? = nil) -> String {

        switch operation {
        case .create:
            fallthrough
        case .getAll:
            return BookResource.root + "books"
        case .delete:
            fallthrough
        case .get:
            fallthrough
        case .update:
            guard let identifier = value else {
                return BookResource.root
            }
            return BookResource.root + "books/\(identifier)"
        }
    }
}

struct Book: ResourceRepresentable {

    static var manager = NetworkManager<Book>()

    static var resourceInformation: RESTResource = BookResource()

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

    init?(data: JSON) {
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

func retrieveAll() {

    Book.manager.retrieve { (books:[Book], error: Error?) in

        if let err = error {
            print("[❌] Error: \(err)")
        }
        else {
            print("[✅] fetched books: \(books)")
        }
    }
}

func retrieve() {

    Book.manager.retrieve(identifier: 1) { (result) in

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

    Book.manager.create(item: book) { (result) in

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

    Book.manager.update(item: book) { (result) in

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

    Book.manager.delete(item: book) { (result) in

        switch result {
        case .success (let book):
            print("[✅] book deleted: \(book)")
        case .error (let error):
            print("[❌] Error: \(error)")
        }
    }
}

delete()

PlaygroundPage.current.needsIndefiniteExecution = true


