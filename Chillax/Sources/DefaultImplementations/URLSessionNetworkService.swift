//
//  URLSessionNetworkService.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

fileprivate enum JSONResult {
    case success (JSON)
    case error (Error)
}

fileprivate enum HTTPResult {
    case success (Data)
    case error (Error)
}

fileprivate enum NetworkManagerError: Error {
    case noURLForOperation
    case noData
    case invalidResponse
    case responseStatus (status: Int)
    case failedRequest (cause:Error)
    case incorrectJSON
    case unknown (Error)
}

public final class URLSessionNetworkService<T:ResourceRepresentable>: NetworkService {

    public func perform(operation: RESTOperation, input: T, callback: @escaping (Result<T>) -> Void) {

        _perform(operation: operation, input: input, callback: callback)
    }

    public func perform(operation: RESTOperation, callback: @escaping (Result<T>) -> Void) {

        _perform(operation: operation, input: nil, callback: callback)
    }

    private func _perform(operation: RESTOperation, input: T?, callback: @escaping (Result<T>) -> Void) {

        httpRequest(item: input, operation: operation) { (result) in

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
    }


    public init() {
        // NO-OP
    }
}

extension URLSessionNetworkService {

    fileprivate func httpRequest(item: T?, operation: RESTOperation, completion: @escaping (HTTPResult) -> Void) {

        let resource = T.resourceInformation
        let request = resource.request(for: operation, fromItem: item)

        URLSession.shared.dataTask(with: request) { data, response, error in

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

        }.resume()
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

extension AnyRESTResource where Result == URLComponents {

    fileprivate func request<T:ResourceRepresentable>(for operation: RESTOperation, fromItem item : T? = nil) -> URLRequest {

        let itemIdentifier = item?.identifier
        let json = item?.jsonRepresentation(for: operation)
        let url = path(for: operation, withIdentifier: itemIdentifier).url!

        var request = URLRequest(url: url)
        request.httpMethod = operation.httpMethod

        switch operation {
        case .retrieve(_):
            break
        case .delete:
            break
        case .create:
            fallthrough
        case .update:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
        }

        return request
    }

}
