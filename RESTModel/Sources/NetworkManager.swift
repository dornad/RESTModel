//
//  ResourceManager.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

public enum Result<T: ResourceRepresentable> {
    case success (T)
    case error (Error)
}

fileprivate enum JSONResult {
    case success (JSON)
    case error (Error)
}

public enum NetworkManagerError: Error {
    case noURLForOperation
    case noData
    case responseStatus (status: Int)
    case failedRequest (cause:Error)
    case incorrectJSON
    case unknown (Error)
}

public final class NetworkManager<T:ResourceRepresentable> {

    public func create(item: T, callback: @escaping (Result<T>) -> Void) {

        let path = T.resourceInformation.path(forOperation: .create)

        guard let url = URL(string: path) else {

            callback( Result.error(NetworkManagerError.noURLForOperation) )
            return
        }

        let json = item.jsonRepresentation(for: .create)

        makeHTTPPostRequest(url: url, json: json) { (postResult) in

            switch postResult {
            case .success(let json):

                print("[⚠️] json: \(json)")

                guard let model = T(data: json) else {
                    callback( Result.error(NetworkManagerError.incorrectJSON) )
                    return
                }
                callback( Result.success(model) )

            case .error(let err):

                callback( Result.error(err) )
            }
        }
    }

    public func retrieve(identifier: Int, callback: @escaping (Result<T>)-> Void) {

        let path = T.resourceInformation.path(forOperation: .get, value: identifier)

        guard let url = URL(string: path) else {

            callback( Result.error(NetworkManagerError.noURLForOperation) )
            return
        }

        makeHTTPGetRequest(url: url) { (getResult) in

            switch getResult {
            case .success(let json):

                print("[⚠️] json: \(json)")

                guard let model = T(data: json) else {
                    callback( Result.error(NetworkManagerError.incorrectJSON) )
                    return
                }
                callback( Result.success(model) )

            case .error(let err):

                callback( Result.error(err) )
            }
        }
    }

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

    fileprivate func makeHTTPPostRequest(url:URL, json:JSON, completion: @escaping (JSONResult) -> Void) {

        do {
            let data = try JSONSerialization.data(
                withJSONObject: json.object,
                options: .prettyPrinted)

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data

            let session = URLSession.shared

            let task = session.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    completion( .error(NetworkManagerError.failedRequest(cause: error)) )
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                    200 ... 299 ~= httpResponse.statusCode else
                {
                    let status = (response as! HTTPURLResponse).statusCode
                    completion(
                        .error(
                            NetworkManagerError.responseStatus(status: status)
                        )
                    )
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
        catch {
            completion(
                .error(
                    NetworkManagerError.unknown(error)
                )
            )
        }
    }

    fileprivate func makeHTTPGetRequest(url:URL, completion: @escaping (JSONResult) -> Void) {

        let request = URLRequest(url: url)

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion( .error(NetworkManagerError.failedRequest(cause: error)) )
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                200 ... 299 ~= httpResponse.statusCode else
            {
                let status = (response as! HTTPURLResponse).statusCode
                completion(
                    .error(
                        NetworkManagerError.responseStatus(status: status)
                    )
                )
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
