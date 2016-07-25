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

    @IBOutlet weak var balancelabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    let itemnames = ["Nike Air", "Adidas Superstar", "Nike Air 2016", "Vans Classic Floral"]
    let price = ["$100", "$100", "$200", "$50"]
    let realprice = [100, 100, 200, 50]
    let images = [3, 0, 5, 7]
    let darks = ["dark2", "dark4", "dark1", "dark3"]
    var totalchange = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(defaults.objectForKey("itemnames") != nil){
            
        }
        self.collectionView!.registerNib(UINib(nibName: "SearchBox", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView!.backgroundColor = UIColor.whiteColor()

    }
    
    override func viewDidAppear(animated: Bool) {
        self.balancelabel.frame.origin = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2+50)

        self.balancelabel.text = "Balance: $\(totalchange)"
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
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SearchBox = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SearchBox
        if(totalchange >= realprice[indexPath.row]){
            cell.appimage.image = UIImage(named: "\(images[indexPath.row])")
        }else{
            cell.appimage.image = UIImage(named: "\(darks[indexPath.row])")
        }
        cell.name.text = itemnames[indexPath.row]
        cell.price.text = price[indexPath.row]
        // Configure the cell
    
        print(cell.price.text)
        return cell
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue){
    }


}
