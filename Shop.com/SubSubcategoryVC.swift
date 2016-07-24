//
//  SubSubcategoryVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/24/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class SubSubcategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias Subcategory = String
    typealias Name = String
    @IBOutlet weak var tableview: UITableView!
    var subsubcategorynames = [String]() //
    var items = [String]()
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsubcategorynames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = subsubcategorynames[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(items)
        self.performSegueWithIdentifier("subsubtoitem", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! ItemsVC
        vc.items = items
    }
}
