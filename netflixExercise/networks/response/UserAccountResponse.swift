//
//  UserAccountResponse.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/16/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation

struct GravatarResponse: Codable {
    let gravatar: HashResponse
}

struct HashResponse: Codable {
    let hash: String
}
struct UserAccountResponse: Codable {
    let avatar: GravatarResponse
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
    


//enum CodingKeys: String, CodingKey {
//
//    case avatar = "avatar"
//    case id = "id"
//    case iso_639_1 = "iso_639_1"
//    case iso_3166_1 = "iso_3166_1"
//    case name = "name"
//    case include_adult = "include_adult"
//    case username = "username"
//    case hash = "hash"
//    case gravatar = ""
//}
}
