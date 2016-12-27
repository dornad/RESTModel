//
//  ResourceManager.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

fileprivate enum JSONResult {
    case success (JSON)
    case error (Error)
}

public enum NetworkManagerError: Error {
    case noURLForOperation
    case incorrectJSON
    case noData
    case failedRequest (cause:Error)
    case unknown (Error)
}

public final class NetworkManager<T:ResourceRepresentable> {

    public func retrieve(callback: @escaping ([T], Error?) -> Void) {

        let path = T.resourceInformation.path(forOperation: .getAll)

        guard let url = URL(string: path) else {

            callback([], NetworkManagerError.noURLForOperation)
            return
        }

        makeHTTPGetRequest(url: url) { (result) in

            switch result {
            case .success(let json):

                guard let jsonArray = json.array else {
                    callback([], NetworkManagerError.incorrectJSON)
                    return
                }
                let models = jsonArray.flatMap { (json_) -> T? in
                    return T(data: json_)
                }
                callback(models, nil)

            case .error(let err):
                callback([], err)
            }
        }
    }

    public init() {
        // NO-OP
    }
}

extension NetworkManager {

    fileprivate func makeHTTPGetRequest(url:URL, completion: @escaping (JSONResult) -> Void) {

        let request = URLRequest(url: url)

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion( .error(NetworkManagerError.failedRequest(cause: error)) )
                return
            }

            guard let data = data else {
                completion( .error(NetworkManagerError.noData) )
                return
            }

            let json = JSON(data: data)

            completion(.success(json))
        }

        task.resume()
    }

}
