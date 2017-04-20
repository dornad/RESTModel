//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Chillax

public protocol Configuration {
    
    var headerFields: [String:String] { get }
    
    var usesBackgroundSession: Bool { get }
}

public protocol RESTResource {
    
    var configuration: Configuration { get set }
    
    var httpBodyProvider: (JSONDictionary) throws -> Data { get }
    
    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable?) -> URLComponents
    
    func parse(data: Data) -> JSON?
}

struct ModelResource: RESTResource {
    
    public struct Config: Configuration {
       
        var headerFields: [String:String] = ["a":"1", "b":"2", "c":"3"]
        var usesBackgroundSession: Bool = false
    }
    
    var configuration: Configuration = Config()
    
    var httpBodyProvider: (JSONDictionary) throws -> Data = { dict -> Data in
        
        return try JSONSerialization.data(withJSONObject: dict, options: [])
    }
    
    func path(for operation: RESTOperation) -> URLComponents {
        return path(for: operation, withIdentifier: nil)
    }
    
    func path(for operation: RESTOperation, withIdentifier identifier: AnyHashable? = nil) -> URLComponents {
        
        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.port = 8080
        components.host = "localhost"
        components.path = "/books"
        return components
    }
    
    func parse(data: Data) -> JSON? {
        return nil
    }
}


let resource = ModelResource()


resource.configuration.headerFields.forEach {
    
    print($0, $1)
    
}

print("----")

for (key,value) in resource.configuration.headerFields {
    print(key, value)
}



PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
