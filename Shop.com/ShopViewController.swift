//
//  ViewController.swift
//  Shop.com
//
//  Created by jeffrey dinh on 7/17/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit
import Alamofire

class ShopViewController: UIViewController {
    
    // API Docs: http://developer.shop.com/documentation
    
    //    //    Method to encode parameters to json
    //        func encodeJson(url: String, params: [String: AnyObject]) -> [String: AnyObject] {
    //            var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
    //            let encoding = Alamofire.ParameterEncoding.URL
    //            (request, _) = encoding.encode(request, parameters: params)
    //            return params
    //        }
    
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
    static var categoryData = [AnyObject]()
    static var categoryNames = [String]()
    static var subcategoryData = [AnyObject]()
    static var subcategoryNames = [String]()
    static var subsubcategoryData = [AnyObject]()
    static var subsubcategoryNames = [String]()
    
    // MARK: - IBActions
    // APN APIs
    @IBAction func categoriesPressed() {
        categories() { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    
    @IBAction func productsPressed() {
        products("")  { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    @IBAction func productIdPressed() {
        productId("")  { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    @IBAction func taxAndShippingPressed() {
        taxAndShipping()  { responseObject, error in
            //print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    // add all category, subcategory, and subsubcategory names to arrays
    @IBAction func allCategoryNamesPressed() {
        categories() { responseObject, error in
            if let categories = responseObject!["categories"] as? [AnyObject] {
                
                // 1st level category
                for category in categories {
                    if let categoryName = category["name"] as? String, subcategories = category["subCategories"] as? [AnyObject] {
                        ShopViewController.categoryData.append(category)
                        ShopViewController.categoryNames.append(categoryName)
                        
                        // 2nd level category
                        for subcategory in subcategories {
                            if let subcategoryName = subcategory["name"] as? String, subsubcategories = subcategory["subCategories"] as? [AnyObject] {
                                ShopViewController.subcategoryData.append(subcategory)
                                ShopViewController.subcategoryNames.append(subcategoryName)
                                
                                // 3rd level category
                                for subsubcategory in subsubcategories {
                                    if let subsubcategoryName = subsubcategory["name"] as? String {
                                        ShopViewController.subsubcategoryData.append(subsubcategory)
                                        ShopViewController.subsubcategoryNames.append(subsubcategoryName)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return
        }
    }
    @IBAction func printz() {
        print("categoryNames is \(ShopViewController.categoryNames)")
        print("subCategoryNames  is \(ShopViewController.subcategoryNames)")
        print("subsubCategoryNames is \(ShopViewController.subsubcategoryNames)")
    }
    
    // method calls alamofire get request and prints JSON response
    // removes dash in ID and does a product call to get all available data for that product
    // A LOT of imageUrls do not work
    // still trying to figure out how to search via product id, some responseObject return nil
    private func parseDashAndProductCall(id: String, categoryName: String, subcategoryName: String) {
        print(id)
        var id = id
        if let dashIndex = id.characters.indexOf("-") {
            id.removeAtIndex(dashIndex)
        
        }
        if let underscore = id.characters.indexOf("_") {
            id = id.substringToIndex(underscore.advancedBy(0))
        }
        productId(id) { responseObject, error in
            print("response is \(responseObject)")
            return
        }
    }
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

