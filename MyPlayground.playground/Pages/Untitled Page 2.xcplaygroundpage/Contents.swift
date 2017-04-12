//: [Previous](@previous)

import Foundation
import PlaygroundSupport

var str = "Hello, playground"

protocol Model {

    init?(JSON: AnyObject)
}


class Service {

    enum FetchType {

    }

    func fetch(what: FetchType) {

    }

    func update() {

    }

    func delete() {

    }

    func save() {

        let url = URL(string:"http://localhost:8080/books")!


        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, _, _) in

            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            print(json)
            }.resume()

    }

}


PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
