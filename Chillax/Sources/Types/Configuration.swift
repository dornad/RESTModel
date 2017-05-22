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
    
    /// Allows adopters to provide their URLSession
    var sessionProvider: () -> URLSession { get }
    
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
    
    public var sessionProvider: () -> URLSession {
        
        return { () -> URLSession in
            
            if case .supported(let identifier) = self.backgroundSessionSupport {
                let urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: identifier)
                return URLSession(configuration: urlSessionConfiguration,
                                  delegate: self.urlSessionDelegate,
                                  delegateQueue: self.urlSessionOperationQueue)
            }
            else {
                return URLSession.shared
            }
        }
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

