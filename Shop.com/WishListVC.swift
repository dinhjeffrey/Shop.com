//
//  WishListVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/21/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WishListVC: UICollectionViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    let itemnames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(defaults.objectForKey("itemnames") != nil){
            
        }
        self.collectionView!.registerNib(UINib(nibName: "SearchBox", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView!.backgroundColor = UIColor.whiteColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemnames.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SearchBox = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SearchBox
    
        // Configure the cell
    
        return cell
    }

}
