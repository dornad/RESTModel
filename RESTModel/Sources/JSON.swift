//
//  JSON.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 12/25/16.
//  Copyright © 2016 REST Models. All rights reserved.
//

import Foundation

public struct JSON {

    var type: JSONType = .null

    /// Private object

    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String : Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber: NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    fileprivate var rawBool: Bool = false

    init(data: Data, options opt: JSONSerialization.ReadingOptions = .allowFragments) {
        do {
            let obj: Any = try JSONSerialization.jsonObject(with: data, options: opt)
            self.init(jsonObject: obj)
        } catch {
            print("error: \(error)")
            self.init(jsonObject: NSNull())
        }
    }

    fileprivate init(jsonObject: Any) {
        self.object = jsonObject
    }

    public var object: Any {
        get {
            switch type {
            case .array:
                return rawArray
            default:
                return rawNull
            }
        }
        set {
            switch newValue {

            case _ as [JSON]:
                type = .array

            case let array as [Any]:
                type = .array
                self.rawArray = array

            case let dictionary as [String : Any]:
                type = .dictionary
                self.rawDictionary = dictionary

            default:
                type = .unknown
            }
        }
    }

}

// MARK: - Array
extension JSON {

    public var array: [JSON]? {

        if type == .array {
            return
                self.rawArray.map({ (rawValue) -> JSON in
                    return JSON(jsonObject: rawValue)
                })
        }

        return nil
    }

    public var dictionary: [String: Any]? {

        if type == .dictionary {
            return self.rawDictionary
        }

        return nil
    }
}

extension JSON {

    public enum JSONType :Int {
        case number
        case string
        case bool
        case array
        case dictionary
        case null
        case unknown
    }
}
