//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 Paperless Post. All rights reserved.
//

import Foundation

internal enum JSONResult {
    case success (JSON)
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

public class URLSessionNetworkService <T:ResourceRepresentable> : NetworkService {

    internal typealias RequestFunctionType = (T?, RESTOperation, @escaping (HTTPResult) -> Void) -> NetworkServiceOperation

    internal var _requestFunction: (RequestFunctionType)!

    public func perform(operation: RESTOperation, input: T, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {

        return _perform(operation: operation, input: input, callback: callback)
    }

    public func perform(operation: RESTOperation, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {

        return _perform(operation: operation, input: nil, callback: callback)
    }

    private func _perform(operation: RESTOperation, input: T?, callback: @escaping (Result<T>) -> Void) -> NetworkServiceOperation {

        let networkServiceOperation = _requestFunction(input, operation) { result in

            switch result {
            case .success(let data):

                guard operation != RESTOperation.delete else {

                    let output = input!
                    callback( Result.success( [output] ) )
                    return
                }

                guard let json = T.resourceInformation.parse(data: data) else {
                    callback( Result.error(NetworkManagerError.incorrectJSON))
                    return
                }

                switch json {

                case .dictionary(let dict):

                    let output = try! T(data: dict)
                    callback( Result.success( [output] ) )

                case .array(let array):

                    let output = array.flatMap { (dict) -> T? in
                        return try? T(data:dict)
                    }
                    callback( Result.success( output ) )
                }

            case .error(let error):

                callback(Result.error(error))
            }
        }
        
        return networkServiceOperation
    }


    public init() {
        _requestFunction = _httpRequest
    }
}

extension RESTOperation {

    var httpMethod: String {
        switch self {
        case .create:
            return "POST"
        case .delete:
            return "DELETE"
        case .retrieve(_):
            return "GET"
        case .update:
            return "PUT"
        }
    }
}


