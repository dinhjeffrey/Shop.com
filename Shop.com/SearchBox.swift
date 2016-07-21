//
//  SearchBox.swift
//  Shop.com
//
//  Created by Andrew  on 7/20/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import Foundation
import UIKit
class SearchBox: UICollectionViewCell{
    @IBOutlet var appimage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBAction func starTapped(sender: AnyObject) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
