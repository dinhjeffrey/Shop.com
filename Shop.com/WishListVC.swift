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
    let itemnames = ["Nike Air", "Adidas Superstar", "Nike Air 2016", "Vans Classic Floral"]
    let price = ["$100", "$100", "$200", "$50"]
    let realprice = [100, 100, 200, 50]
    let images = [3, 0, 5, 7]
    let darks = ["dark2", "dark4", "dark1", "dark3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(defaults.objectForKey("itemnames") != nil){
            
        }
        self.collectionView!.registerNib(UINib(nibName: "SearchBox", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView!.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewDidAppear(animated: Bool) {
        let totalchange = defaults.integerForKey("change")
        self.navigationItem.title = "Balance: $\(totalchange)"
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SearchBox = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SearchBox
      
        let totalchange = defaults.integerForKey("change")
        if((totalchange / 100) >= realprice[indexPath.row]){
            print("more")
            cell.appimage.image = UIImage(named: "\(images[indexPath.row])")
        }else{
            cell.appimage.image = UIImage(named: "\(darks[indexPath.row])")
        }
        cell.name.text = itemnames[indexPath.row]
        cell.price.text = price[indexPath.row]
        // Configure the cell
        return cell
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue){
    }


}
