//
//  SubcategoryVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/21/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

class SubcategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        //cell?.textLabel?.text = sched[indexPath.row] as! String
        return cell!
    }}
