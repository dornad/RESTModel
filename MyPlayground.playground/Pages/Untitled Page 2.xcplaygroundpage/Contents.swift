//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// OLD CODE - UNTOUCHED

//protocol Configuration {
//    
//}
//
//enum ResourceError: Error {
//    case invalidURL
//}
//
//protocol Resource {
//    
//    func request(for: Operation, from: Model?) throws -> URLRequest
//}
//
//extension Resource {
// 
//    func request(for operation: Operation, from: Model?) throws -> URLRequest {
//        
//        guard let url = operation.urlComponents.url else {
//            throw ResourceError.invalidURL
//        }
//        return URLRequest(url: url)
//    }
//}
//
//protocol Model {
//    
//    static var resource: Resource { get }
//}
//
//protocol Operation {
//    
//    static var modelType: Model.Type { get }
//    
//    var urlComponents: URLComponents { get }
//    
//    func urlSession() -> URLSession
//}
//
//enum ResultOne <T: Model> {
//    case success(T)
//    case failure(Error)
//}
//
//enum ResultArray <T: Model> {
//    case success([T])
//    case failure(Error)
//}
//
//enum BaseOperations: Operation {
//    
//    case fetchBy(id: AnyHashable, response: (Error) -> Void)
//    case fetchAll(response: ([T]) -> Void)
//    case create(model: T, response: (T) -> Void)
//    case update(model: T, response: (T) -> Void)
//    case delete(model: T, response: (T) -> Void)
//    
//    static var modelType: Model.Type {
//        return T.self
//    }
//}
//
//extension BaseOperations {
//    
//    var urlComponents: URLComponents {
//        switch self {
//        case .create(let model, _):
//            break
//        case .fetch(_):
//            break
//        case .fetchBy(let id, _):
//            break
//        case .update(let model, _):
//            break
//        case .delete(let model, _):
//            break
//        }
//        return URLComponents(string: "")!
//    }
//    
//    func urlSession() -> URLSession {
//        return URLSession.shared
//    }
//}
//
//protocol PendingOperation {
//    func start()
//    func cancel()
//}
//
//
//class Service <T: Operation> {
//    
//    typealias NetworkFunction = (URLSession, URLRequest, T) -> PendingOperation
//    
//    var _networkActivityFunction: NetworkFunction! = nil
//    
//    struct PendingOperationImp: PendingOperation {
//        var task: URLSessionDataTask
//        func start() { task.resume() }
//        func cancel() { task.cancel() }
//    }
//    
//    func perform(operation: T) -> PendingOperation? {
// 
//        // get the resource
//        let resource = T.modelType.resource; print("1")
//        
//        // setup and get the request
//        let request = try! resource.request(for: operation, from: nil) ; print("2")
//        
//        // setup the URLSession
//        let urlSession = operation.urlSession(); print("3")
//        
//        // hit the network
//        guard let _networkActivityFunction = _networkActivityFunction else { return nil }
//        let pendingNetwork = _networkActivityFunction(urlSession, request, operation); print("4")
//        
//        return pendingNetwork
//    }
//}
//
//typealias UserOperation = BaseOperations<User>
//
//struct UserResource: Resource {
//    
//}
//
//struct User: Model {
//    
//    static var resource: Resource = UserResource()
//}
//
//let service = Service<UserOperation>()
//
//service.perform(operation: UserOperation.fetchAll(response: { models in
//    
//}))



PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
