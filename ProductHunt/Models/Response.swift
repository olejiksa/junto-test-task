//
//  Response.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let posts: [Post]
}

struct TopicResponse: Decodable {
    let topics: [Topic]
}
