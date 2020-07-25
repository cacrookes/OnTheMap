//
//  LoginResponse.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-24.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    struct Account: Codable {
        let registered: Bool
        let key: String
    }
    struct Session: Codable {
        let id: String
        let expiration: String
    }
    
    let account: Account
    let session: Session
}
