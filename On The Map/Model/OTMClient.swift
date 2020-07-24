//
//  OTMClient.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-23.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class OTMClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations(Int)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit):
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(limit)"
            }
        }
    }
    
}
