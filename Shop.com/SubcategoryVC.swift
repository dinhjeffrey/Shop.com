//
//  SubcategoryVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/24/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class SubcategoryVC: UIViewController {
    typealias Category = String
    typealias Name = String
    var names = [Category: [Name]]()
    @IBOutlet weak var tableview: UITableView!
}
