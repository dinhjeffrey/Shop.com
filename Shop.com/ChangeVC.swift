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
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let vc = unwindSegue.destinationViewController as! WishListVC
        let totalchange = defaults.integerForKey("change")
        let x = Int(change.text!)! / 100
        defaults.setInteger(totalchange + x, forKey: "change")
    }
}
