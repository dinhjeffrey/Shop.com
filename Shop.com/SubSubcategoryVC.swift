//
//  SubSubcategoryVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/24/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class SubSubcategoryVC: UIViewController {
    typealias Subcategory = String
    typealias Name = String
    var names = [Category: [Subcategory: [Name]]]() //
    @IBOutlet weak var tableview: UITableView!
}
