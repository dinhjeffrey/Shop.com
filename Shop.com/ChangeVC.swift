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

    let defaults = NSUserDefaults.standardUserDefaults()
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let vc = unwindSegue.destinationViewController as! WishListVC
        let totalchange = defaults.integerForKey("change")
        let x = Int(change.text!)! / 100
        defaults.setInteger(totalchange + x, forKey: "change")
    }
}
