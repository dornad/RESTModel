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
    var backgroundSessionSupport: BackgroundSessionSupport { get }
    
    /// An optional URL Session delegate.
    ///
    /// Default behavior is to return `nil`
    var urlSessionDelegate: URLSessionDelegate? {get}
    
    /// An optional operation queue for the URL Session.
    ///
    /// Default behavior is to return `nil`
    var urlSessionOperationQueue: OperationQueue? { get }
}

extension Configuration {
    
    public var urlSessionDelegate: URLSessionDelegate? {
        return nil
    }
    
    public var urlSessionOperationQueue: OperationQueue? {
        return nil
    }
}

/// Configuration data for Background Sessions.
///
/// - notSupported: The background session is not supported
/// - supperted: The background session is supported with an identifier (String)
public enum BackgroundSessionSupport {
    /// not supported
    case notSupported
    /// Supported with identifier (`String`)
    case supported (String)
}

