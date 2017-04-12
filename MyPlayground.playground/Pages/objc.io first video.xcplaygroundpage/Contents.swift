//: [Previous](@previous)

import Foundation
import PlaygroundSupport

struct Episode {

    let id: String
    let title: String
}

typealias JSONDictionary = [String: AnyObject]

extension Episode {

    // why init in extension: this way default initializer is still available.
    init?(dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] else { return nil }

        self.id = id
        self.title = title
    }
}

struct Media {}

let url = URL(string: "http://localhost:8080/episodes")!

struct Resource<A> {

    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, parseJSON: (AnyObject) -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}


let episodesResource = Resource<[Episode]>(url: url, parseJSON: { json in

    guard let dictionaries = json as? [NSDictionary] else { return nil }
    return dictionaries.flatMap(Episode.init(dictionary:))
})

final class WebService {

    func load<A>(resource: Resource<A>, completion: @escaping (A?)-> ()) {

        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
}

WebService().load(resource: episodesResource) { result in
    print(result)
}

PlaygroundPage.current.needsIndefiniteExecution = true


//: [Next](@next)
