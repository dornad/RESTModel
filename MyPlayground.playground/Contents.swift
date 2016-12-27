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
            return BookResource.root + "book"
        case .getAll:
            return BookResource.root + "books"
        case .delete:
            fallthrough
        case .get:
            fallthrough
        case .update:
            return BookResource.root + "books/\(value!)"
        }
    }
}

struct Book: ResourceRepresentable {

    static var manager = NetworkManager<Book>()

    static var resourceInformation: RESTResource = BookResource()

    let id: Int
    let title:String
    let author:String
    let isbn: String

    init(id id_:Int, title title_:String, author author_:String, isbn isbn_:String) {
        id = id_
        title = title_
        author = author_
        isbn = isbn_
    }

    init?(data: JSON) {
        id = data.dictionary?["id"] as? Int ?? 0
        title = data.dictionary?["title"] as? String ?? ""
        author = data.dictionary?["author"] as? String ?? ""
        isbn = data.dictionary?["isbn"] as? String ?? ""
    }
}

Book.manager.retrieve { (books:[Book], error: Error?) in

    if let err = error {
        print("[❌] Error: \(err)")
    }
    else {
        print("[✅] books: \(books)")
    }
}

Book.manager.retrieve(identifier: 1) { (result) in

    switch result {
    case .success (let book):
        print("[✅] book: \(book)")
    case .error (let error):
        print("[❌] Error: \(error)")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
