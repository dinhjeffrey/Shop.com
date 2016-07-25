//
//  ChangeVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/24/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class ChangeVC: UIViewController {
    @IBOutlet weak var change: UITextField!

    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let vc = unwindSegue.destinationViewController as! WishListVC
        let x = Int(change.text!)
        vc.totalchange += x!
    }
}
