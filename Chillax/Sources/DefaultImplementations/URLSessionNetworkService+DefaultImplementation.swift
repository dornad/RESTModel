//
//  URLSessionNetworkService+DefaultImplementation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

extension URLSessionNetworkService {
    
    private struct _OperationImplementation: NetworkServiceOperation {
        var task: URLSessionDataTask
        
        func start() {
            task.resume()
        }
        
        func cancel() {
            task.cancel()
        }
    }
    
    private struct ErroredOperation: NetworkServiceOperation {
        func cancel() { }
        func start() { }
    }
    
    internal func _httpRequest(operation: ChillaxOperation, completion: @escaping (HTTPResult) -> Void) -> NetworkServiceOperation {

        // Retrieve the resource
        
        let resource = T.resourceInformation

        // Ask the `Resource` to build the `URLRequest` for our operation and model ('item')
        
        let request: URLRequest
        do {
            
            request = try resource.request(for: operation)
        }
        catch {
            completion( .error(NetworkManagerError.failedRequest(cause: error)) )
            return ErroredOperation()
        }
        
        // Retrieve the `URLSession` from the configuration information in the `Resource`
        
        let urlSession = resource.configuration.sessionProvider()
        
        // Finally, hit the network.
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion( .error(NetworkManagerError.failedRequest(cause: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion ( .error(NetworkManagerError.invalidResponse) )
                return
            }
            
            guard 200 ... 299 ~= httpResponse.statusCode else {
                let status = httpResponse.statusCode
                completion( .error(NetworkManagerError.responseStatus(status: status)))
                return
            }
            
            guard let data = data else {
                completion( .error(NetworkManagerError.noData))
                return
            }
            
            completion( .success(data) )            
        }
        
        return _OperationImplementation(task: task)
    }
}
