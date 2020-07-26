//
//  ErrorResponse.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-25.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}
