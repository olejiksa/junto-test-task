//
//  ProductTableViewCell.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var votesCount: UILabel!
    
}
