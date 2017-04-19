//
//  URLSessionNetworkService+DefaultImplementation.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/14/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

extension URLSessionNetworkService {
    
    private struct ErroredOperation: NetworkServiceOperation {
        func cancel() { }
        func start() { }
    }

    internal func _httpRequest(item: T?, operation: RESTOperation, completion: @escaping (HTTPResult) -> Void) -> NetworkServiceOperation {

        let resource = T.resourceInformation

        guard let request = resource.request(for: operation, fromItem: item) else {

            let error = NSError(domain: "", code: 1, userInfo: nil)
            completion( .error(NetworkManagerError.failedRequest(cause: error)) )
            return ErroredOperation()
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
        
        return task
    }
}

extension URLSessionDataTask : NetworkServiceOperation {
    
    public func start() {
        self.resume()
    }
}
