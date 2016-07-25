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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
     var jsonData = [String: AnyObject]()
     var categoryData = [AnyObject]()
     var categoryNames = [String]()
     var categoryImageUrls = [String]()
     var subcategoryData = [AnyObject]()
     var subcategoryNames = [[String]]()
     var subcategoryImageUrls = [String]()
     var subsubcategoryData = [AnyObject]()
     var subsubcategoryNames = [[[String]]]()
     var itemNamesAndImageUrls = [[[String]]]() // triply nested because each subsubcategory name can have a list of items returned when calling product API [ [ [name, imageurl], [name, imageurl] ] ]
    

    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        allCategoryNamesPressed()
        activityIndicator.startAnimating()
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
        self.performSegueWithIdentifier("subcategory", sender: self)
        // }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "items"){
            if let vc = segue.destinationViewController as? ItemsVC {
                
            }
            //Search for items here
            
            //vc.itemnames =
            
        }else{
            let vc = segue.destinationViewController as! SubcategoryVC
            vc.subcategorynames = subcategoryNames[number]
            vc.subsubcategorynames = subsubcategoryNames[number]            
            vc.items = [["items"]] //fixed flooding api call //itemNamesAndImageUrls[number]
        }
    }
    
    
    // MARK: - IBActions
    // APN APIs
    func categoriesPressed() {
        categories() { responseObject, error in
           // print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    
    func productsPressed() {
        products("")  { responseObject, error in
           // print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func productIdPressed() {
        productId()  { responseObject, error in
           // print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func taxAndShippingPressed() {
        taxAndShipping()  { responseObject, error in
           // print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    func allCategoryNamesPressed() {
        categories() { [weak weakSelf = self] responseObject, error in
            if let categories = responseObject!["categories"] as? [AnyObject] {
                
                // 1st level category
                for (index1, category) in categories.enumerate() {
                    if let categoryName = category["name"] as? String, subcategories = category["subCategories"] as? [AnyObject] {
                        self.categoryData.append(category)
                        self.categoryNames.append(categoryName)
                        
                        // 2nd level category
                        // categorynNames = [names]
                        // subcategorynames [[name, name, name][String][String]]
                        for (index2, subcategory) in subcategories.enumerate() {
                            if let subcategoryName = subcategory["name"] as? String, subsubcategories = subcategory["subCategories"] as? [AnyObject] {
                                self.subcategoryData.append(subcategory)
                                guard self.subcategoryNames.indices.contains(index1) != false else {
                                    self.subcategoryNames.append([subcategoryName])
                                    continue
                                }
                                self.subcategoryNames[index1].append(subcategoryName)
                                
                                // 3rd level category
                                for subsubcategory in subsubcategories { // [[[ subsubName,   ]]]
                                    if let subsubcategoryName = subsubcategory["name"] as? String {
                                        self.subsubcategoryData.append(subsubcategory)
                                        guard self.subsubcategoryNames.indices.contains(index1) != false else {
                                            self.subsubcategoryNames.append([[subsubcategoryName]])
                                            continue
                                        }
                                        guard self.subsubcategoryNames[index1].indices.contains(index2) != false else {
                                            self.subsubcategoryNames[index1].append([subsubcategoryName])
                                            continue
                                        }
                                        self.subsubcategoryNames[index1][index2].append(subsubcategoryName)
                                    }  else {
                                        self.subsubcategoryNames.append([[" "]])
                                    }
                                }
                            } else {
                                self.subcategoryNames.append([" "])
                            }
                        }
                    } else {
                        self.categoryNames.append(" ")
                    }
                }
            }
            self.reloadTable()
            //self.imageUrlsPressed()
            weakSelf?.activityIndicator.stopAnimating()
            return
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
                //print(response.result)   // result of response serialization
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
    
    func imageUrlsPressed() {
        // loop through each category
        for category in self.subsubcategoryNames {
            // loop through each subcategory
            for subcategory in category {
                // loop through each name in subsubcategory
                for (index, subsubcategoryName) in subcategory.enumerate() {
                    // adds a lot of [name, imageurl] for each subsubcategory. calls product api on the name
                    itemNamesAndimageUrls(subsubcategoryName, index: index)
                }
            }
        }
    }

    func itemNamesAndimageUrls(name: String, index: Int) {
        products(name) { responseObject, error in
            //print("response OBJECT is: \(responseObject)")
            if let products = responseObject?["products"] as? [AnyObject] {
                for product in products {
                    if let name = product["name"] as? String, imageUrl = product["imageUrl"] as? String, description = product["description"] as? String, price = product["minimumPrice"] as? String {
                        guard self.itemNamesAndImageUrls.indices.contains(index) != false else {
                            self.itemNamesAndImageUrls.append([[name, imageUrl, description, price]])
                            continue
                        }
                        self.itemNamesAndImageUrls[index].append([name, imageUrl, description, price])
                    } else {
                        self.itemNamesAndImageUrls[index].append([" "])
                    }
                }
            }  else {
                self.itemNamesAndImageUrls.append([[" "]])
            }
            //print("items is: \(ShopViewController.itemNamesAndImageUrls)")
            return
        }    }

    
    
    

}
