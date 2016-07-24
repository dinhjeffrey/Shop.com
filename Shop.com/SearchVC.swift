//
//  SearchVC.swift
//  Shop.com
//
//  Created by Andrew  on 7/20/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var tableview: UITableView!
    // MARK: - global constants and variables
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    let params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = [
        "apikey": "l7xxc296eff5fe82405aa19d43106e218ab6"
    ]
    typealias Category = String
    typealias Subcategory = String
    typealias Name = String
    static var jsonData = [String: AnyObject]()
    var categoryData = [AnyObject]()
    var categoryNames = [String]()
    var categoryImageUrls = [String]()
    var subcategoryData = [AnyObject]()
    var subcategoryNames = [[String]]()
    var subcategoryImageUrls = [String]()
    var subsubcategoryData = [AnyObject]()
    var subsubcategoryNames = [[String]]()
    var subsubcategoryImageUrls = [String]()
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        allCategoryNamesPressed()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = categoryNames[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        number = indexPath.row
        //if(subcategoryNames[number] == " "){
       //     self.performSegueWithIdentifier("items", sender: self)
        //}else{
            print(subcategoryNames[number])
            self.performSegueWithIdentifier("subcategory", sender: self)
       // }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "items"){
            let vc = segue.destinationViewController as! ItemsVC
            //Search for items here
            
            //vc.itemnames =

        }else{
            let vc = segue.destinationViewController as! SubcategoryVC
            vc.subcategorynames = subcategoryNames[number]
        }
    }
    
    // MARK: - IBActions
    // APN APIs
    func categoriesPressed() {
        categories() { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    
    func productsPressed() {
        products("")  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func productIdPressed() {
        productId("")  { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func taxAndShippingPressed() {
        taxAndShipping()  { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    // add all category, subcategory, and subsubcategory names to arrays
    func allCategoryNamesPressed() {
        categories() { responseObject, error in
            if let categories = responseObject!["categories"] as? [AnyObject] {
                
                // 1st level category
                for (index1, category) in categories.enumerate() {
                    if let categoryName = category["name"] as? String, subcategories = category["subCategories"] as? [AnyObject] {
                        ShopViewController.categoryData.append(category)
                        ShopViewController.categoryNames.append(categoryName)
                        
                        // 2nd level category
                        // categorynNames = [names]
                        // subcategorynames [[name, name, name][String][String]]
                        for (index2, subcategory) in subcategories.enumerate() {
                            if let subcategoryName = subcategory["name"] as? String, subsubcategories = subcategory["subCategories"] as? [AnyObject] {
                                ShopViewController.subcategoryData.append(subcategory)
                                guard ShopViewController.subcategoryNames.indices.contains(index1) != false else {
                                    ShopViewController.subcategoryNames.append([subcategoryName])
                                    continue
                                }
                                ShopViewController.subcategoryNames[index1].append(subcategoryName)
                                
                                // 3rd level category
                                for subsubcategory in subsubcategories {
                                    if let subsubcategoryName = subsubcategory["name"] as? String {
                                        ShopViewController.subsubcategoryData.append(subsubcategory)
                                        guard ShopViewController.subsubcategoryNames.indices.contains(index2) != false else {
                                            ShopViewController.subsubcategoryNames.append([subsubcategoryName])
                                            continue
                                        }
                                        ShopViewController.subsubcategoryNames[index2].append(subsubcategoryName)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.tableview.reloadData()
            return
        }
    }
    func imageUrlsPressed() {
        for (index, element) in ShopViewController.categoryNames.enumerate() {
            imageUrls(element)
        }
    }
    // method calls alamofire get request and prints JSON response
    // removes dash in ID and does a product call to get all available data for that product
    // A LOT of imageUrls do not work
    // still trying to figure out how to search via product id, some responseObject return nil
    
    
    private func alamofireRequest(url: String, parameters: [String: String], completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        Alamofire.request(
            .GET,
            url,
            parameters: parameters,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? [String: AnyObject], nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
                
                if let JSON = response.result.value as? [String: AnyObject] {
                    //print("JSON: \(JSON)")
                    ShopViewController.jsonData = JSON
                }
        }
    }
    
    // MARK: - APN API methods
    func categories(completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        let url = self.url + "categories"
        alamofireRequest(url, parameters: params, completionHandler: completionHandler)
    }
    
    func products(term: String, completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        let url = self.url + "products"
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "start": "", // defaults to 0
            "perPage": "", // defaults to 15
            "term": "General Use Sealants",//term,
            "categoryId": "",
            "brandId": "",
            "sellerId": "",
            "priceRangeId": "" // i.e. "[0.0 TO 10.00]"
        ]
        alamofireRequest(url, parameters: params, completionHandler: completionHandler)
    }
    
    func productId(id: String, completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        let id = id
        let url = self.url + "products/\(id)"
        alamofireRequest(url, parameters: params, completionHandler: completionHandler)
    }
    
    func taxAndShipping(completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        let url = self.url + "taxandshipping"
        
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "prodIds": "749443420", // required
            "quantity": "1", // required
            "zip": "92841", // required
            "state": "",
            "city": "",
            "country": "",
            "street": ""
        ]
        alamofireRequest(url, parameters: params, completionHandler: completionHandler)
    }
    private func imageUrls(name: String) {
        products(name) { responseObject, error in
            if let products = responseObject?["products"] as? [AnyObject] {
                for product in products {
                    if let imageUrl = product["imageUrl"] as? String {
                        ShopViewController.categoryImageUrls.append(imageUrl)
                    }
                }
                print(ShopViewController.categoryNames.count)
                print(ShopViewController.categoryImageUrls.count)
                return
            }
        }
    }
    

}

