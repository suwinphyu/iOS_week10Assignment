//
//  UserResponse.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation
struct UserResponse : Codable {
    let request_token : String?
    let session_id : String?
    let code : Int?
    let success : Bool?
    let id : Int?
    let username : String?
    
    
        enum CodingKeys: String, CodingKey {
            case request_token = "request_token"
            case session_id = "session_id"
            case code = "code"
            case success = "success"
            case id = "id"
            case username = "username"
       
        }
}


