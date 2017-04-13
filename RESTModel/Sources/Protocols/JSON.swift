//
//  JSON.swift
//  RESTModel
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 REST Models. All rights reserved.
//

import Foundation

/// A typealias for `[String:Any]`
public typealias JSONDictionary = [String: Any]

/// A enumeration used for JSON results:  Dictionaries or Arrays.
public enum JSON {
    case dictionary (JSONDictionary)
    case array ([JSONDictionary])
}
