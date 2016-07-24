//
//  SubcategoryVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/24/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class SubcategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    typealias Category = String
    typealias Name = String
    var subcategorynames = [String]()
    var subsubcategorynames = [[String]]()
    var items = [[String]]()
    var number = 0
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategorynames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = subcategorynames[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        number = indexPath.row
        //if(subcategoryNames[number] == " "){
        //     self.performSegueWithIdentifier("subtoitem", sender: self)
        //}else{
        self.performSegueWithIdentifier("subsubcategory", sender: self)
        // }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "subtoitem"){
            let vc = segue.destinationViewController as! ItemsVC
            
        }else{
            let vc = segue.destinationViewController as! SubSubcategoryVC
            vc.subsubcategorynames = subsubcategorynames[number]
            vc.items = items

        }
    }
}

