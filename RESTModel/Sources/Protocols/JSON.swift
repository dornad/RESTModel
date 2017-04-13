//
//  JSON.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

/// `[String:Any]`

public typealias JSONDictionary = [String: Any]

public enum JSON {
    case dictionary (JSONDictionary)
    case array ([JSONDictionary])
}


extension RESTResource {

    public func parse(data: Data) -> JSON? {

        let json = try? JSONSerialization.jsonObject(with: data, options: [])

        if json is [JSONDictionary] {

            return JSON.array( (json as! [JSONDictionary]) )
        }
        else if json is JSONDictionary {

            return JSON.dictionary( json as! JSONDictionary )
        }

        return nil
    }

}
