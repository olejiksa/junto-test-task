//
//  DetailViewController.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 29.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var votesCountLabel: UILabel!
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    var receivedData: Post?
    
    @IBAction private func openUrl(_ sender: UIButton) {
        if let url = URL(string: receivedData!.redirectUri) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = receivedData!.title
        descriptionLabel.text = receivedData!.description
        votesCountLabel.text = String(describing: receivedData!.votesCount)
        screenshotImageView?.sd_setImage(with: URL(string: receivedData!.screenshotUri.uri))
    }
    
}
