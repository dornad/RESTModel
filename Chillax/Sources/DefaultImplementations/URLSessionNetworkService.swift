//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import Foundation

internal enum JSONResult {
    case success (Data)
    case error (Error)
}

internal enum HTTPResult {
    case success (Data)
    case error (Error)
}

internal enum NetworkManagerError: Error {
    case noURLForOperation
    case noData
    case invalidResponse
    case responseStatus (status: Int)
    case failedRequest (cause:Error)
    case incorrectJSON
    case unknown (Error)
}

public class URLSessionNetworkService <T:Resource> : NetworkService {

    internal typealias RequestFunctionType = (ChillaxOperation, @escaping (HTTPResult) -> Void) -> NetworkServiceOperation

    internal var _requestFunction: (RequestFunctionType)!

    public func perform(operation: ChillaxOperation, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {

        let networkServiceOperation = _requestFunction(operation) { result in
            
            switch result {
            
            case .error(let error):
                callback(Result.error(error))
                
            case .success(let data):
                guard operation.expectsJSONResponse else {
                    callback( Result.success([]) )
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let element = try jsonDecoder.decode(T.self, from: data)
                    callback( Result.success([element]))
                }
                catch {
                    self._attemptArrayDecoding(decoder: jsonDecoder, data: data, callback: callback)
                }
            }
        }
        
        return networkServiceOperation
    }

    
    private func _attemptArrayDecoding(decoder: JSONDecoder, data: Data, callback: @escaping (Result<T>) -> Void) {
        do {
            let array = try decoder.decode([T].self, from: data)
            callback( Result.success(array))
        }
        catch {
            callback( Result.error(error) )
        }
    }

    public init() {
        _requestFunction = _httpRequest
    }
}
