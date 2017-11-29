//
//  Post.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let title: String
    let description: String
    let votesCount: Int
    let picture: Thubmnail
    let redirectUri: String
    let screenshotUri: Screenshot
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "name"
        case description = "tagline"
        case votesCount = "votes_count"
        case picture = "thumbnail"
        case redirectUri = "redirect_url"
        case screenshotUri = "screenshot_url"
    }
    
    struct Thubmnail: Decodable {
        let id: Int
        let imageUri: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case imageUri = "image_url"
        }
    }
    
    struct Screenshot: Decodable {
        let uri: String
        
        enum CodingKeys: String, CodingKey {
            case uri = "300px"
        }
    }
}
