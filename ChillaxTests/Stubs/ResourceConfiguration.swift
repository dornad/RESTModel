//
//  ResourceConfiguration.swift
//  Chillax
//
//  Created by Daniel Rodriguez on 4/20/17.
//  Copyright © 2017 Paperless Post. All rights reserved.
//

import Foundation
@testable import Chillax

struct ResourceConfiguration: Configuration {
    
    var headerFields: [String : String] = ["Content-Type": "application/json"]
    
    var backgroundSessionSupport: BackgroundSessionSupport = .notSupported
}
