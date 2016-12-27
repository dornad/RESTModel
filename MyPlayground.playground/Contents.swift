//: Playground - noun: a place where people can play

import UIKit
import RESTModel
import PlaygroundSupport

struct BookResource: RESTResource {

    static let root = "http://localhost:8080/"

    func path(forOperation operation: RESTOperation) -> String {

        switch operation {
        case .create:
            break
        case .delete:
            break
        case .get:
            break
        case .getAll:
            return BookResource.root + "books"
        case .update:
            break
        }

        return ""
    }

}

struct Book: ResourceRepresentable {

    static var manager = NetworkManager<Book>()

    static var resourceInformation: RESTResource = BookResource()

    let id: Int
    let title:String
    let author:String
    let isbn: String

    init?(data: JSON) {
        id = data.dictionary?["id"] as? Int ?? 0
        title = data.dictionary?["title"] as? String ?? ""
        author = data.dictionary?["author"] as? String ?? ""
        isbn = data.dictionary?["isbn"] as? String ?? ""
    }
}

Book.manager.retrieve { (books:[Book], error: Error?) in

    if let err = error {
        print(err)
    }
    else {
        print("\(#function) books: \(books)")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
