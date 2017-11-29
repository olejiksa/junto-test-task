//
//  Topic.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import Foundation

struct Topic: Decodable {
    let id: Int
    let name: String
    let slug: String
}
