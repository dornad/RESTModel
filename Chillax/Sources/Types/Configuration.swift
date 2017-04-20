//
//  Configuration.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/20/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation


/// A type holding Configuration information that can be reused by 
/// several Models.
public protocol Configuration {
    
    /// the header fields that should be configured in the URLRequest.
    var headerFields: [String:String] { get }
    
    /// Provides support for background sessions in `URLSession`.
    var usesBackgroundSession: Bool { get }
}
