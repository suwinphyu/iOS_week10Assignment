//
//  GetVideoResponse.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/15/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation

struct VideoListResponse: Codable {
    let id: Int
    let results: [GetVideoResponse]
}
struct GetVideoResponse : Codable {
    
    let id : String
    let iso_639_1 : String
    let iso_3166_1 : String
    let key : String
    let name : String
    let site : String
    let size: Int
    let type : String
    
}
