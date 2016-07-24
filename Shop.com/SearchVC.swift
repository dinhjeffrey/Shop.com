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
    typealias Category = String
    typealias Subcategory = String
    typealias Name = String
    static var jsonData = [String: AnyObject]()
    var categoryNames = [AnyObject]()
    var subcategoryNames = [Category: [Name]]()
    var subsubcategoryNames = [Category: [Subcategory: [Name]]]() //
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
        cell?.textLabel?.text = categoryNames[indexPath.row] as! String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        number = indexPath.row
        let tempnames = subcategoryNames.values
        print(tempnames)
        //self.performSegueWithIdentifier("subcategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! SubcategoryVC

    }
    
    
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    let params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = [
        "apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"
    ]
    
    // MARK: - IBActions
    // APN APIs
    func categoriesPressed() {
        categories() { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
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
        productId()  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func taxAndShippingPressed() {
        taxAndShipping()  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func allCategoryNamesPressed() {
        categories() { responseObject, error in
            if let categories = responseObject!["categories"] as? [AnyObject] {
                
                // 1st level category. loops through each category and gets the name and appends it to the array
                for category in categories {
                    if let name = category["name"] as? String, subcategories = category["subCategories"] as? [AnyObject] {
                        self.categoryNames.append(name)
                        
                        // 2nd level category
                        for subcategory in subcategories {
                            if let subcategoryName = subcategory["name"] as? String, subsubcategories = subcategory["subCategories"] as? [AnyObject] {
                                guard self.subcategoryNames[name] != nil else {
                                    self.subcategoryNames[name] = [subcategoryName]
                                    self.subsubcategoryNames[name] = [subcategoryName: []]
                                    continue }
                                self.subcategoryNames[name]?.append(subcategoryName)
                                
                                // 3rd level category.
                                for subsubcategory in subsubcategories {
                                    if let subsubcategoryName = subsubcategory["name"] as? String{
                                        guard self.subsubcategoryNames[name]![subcategoryName] != nil else { self.subsubcategoryNames[name]![subcategoryName] = [subsubcategoryName]; continue }
                                        self.subsubcategoryNames[name]![subcategoryName]?.append(subsubcategoryName)

                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            print(self.subsubcategoryNames)
            print("-----------")
            print(self.subcategoryNames)
            self.defaults.setValue(self.subcategoryNames, forKeyPath: "subcategorynames")
            self.defaults.setValue(self.subsubcategoryNames, forKeyPath: "subsubcategorynames")

            self.reloadTable()
        }
    }
    
    func reloadTable(){
        self.tableview.reloadData()
        self.tableview.reloadInputViews()
    }
    // method calls alamofire get request and prints JSON response
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
            "term": term,
            "categoryId": "",
            "brandId": "",
            "sellerId": "",
            "priceRangeId": "" // i.e. "[0.0 TO 10.00]"
        ]
        alamofireRequest(url, parameters: params, completionHandler: completionHandler)
    }
    
    func productId(completionHandler: ([String: AnyObject]?, NSError?) -> ()) {
        let id = "834207132"
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
    
    
    
    
    

}
