//
//  LoginRequest.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-24.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    struct LoginCredentials: Codable {
        let username: String
        let password: String
    }
    
    let udacity: LoginCredentials
}
