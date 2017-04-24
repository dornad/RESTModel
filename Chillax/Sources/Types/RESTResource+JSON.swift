//
//  RESTResource+JSON.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/13/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation

// MARK: `RESTResource` default implementation of `parse(data:)`

private enum JSONParseError: Error {
    case notDictionaryOrArray
}

extension RESTResource {
    

    /// Parse data from the backend into a JSON Dictionary.
    ///
    /// - Parameter data: Data from the backend
    /// - Returns: A `JSON`, either a Dictionary or Array of Dictionaries
    public func parse(data: Data) -> JSON {

        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if json is [JSONDictionary] {
                
                return JSON.array( (json as! [JSONDictionary]) )
            }
            else if json is JSONDictionary {
                
                return JSON.dictionary( json as! JSONDictionary )
            }
            else {
                
                return JSON.notJSON(details: JSONParseError.notDictionaryOrArray)
            }
        }
        catch {
            
            return JSON.notJSON(details: error)
        }
    }

}
