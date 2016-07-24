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
        "apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"
    ]
    typealias Category = String
    typealias Subcategory = String
    typealias Name = String
    static var jsonData = [String: AnyObject]()
    static var categoryNames = [Name]()
    static var subcategoryNames = [Category: [Name]]()
    static var subsubcategoryNames = [Category: [Subcategory: [Name]]]() //
    
    // MARK: - IBActions
    // APN APIs
    @IBAction func categoriesPressed() {
        categories() { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    
    @IBAction func productsPressed() {
        products("")  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    @IBAction func productIdPressed() {
        productId()  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    @IBAction func taxAndShippingPressed() {
        taxAndShipping()  { responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            return
        }
    }
    @IBAction func allCategoryNamesPressed() {
        categories() { responseObject, error in
            if let categories = responseObject!["categories"] as? [AnyObject] {
                
                // 1st level category. loops through each category and gets the name and appends it to the array
                for category in categories {
                    if let name = category["name"] as? String, subcategories = category["subCategories"] as? [AnyObject] {
                        ShopViewController.categoryNames.append(name)
                        
                        // 2nd level category
                        for subcategory in subcategories {
                            if let subcategoryName = subcategory["name"] as? String, subsubcategories = subcategory["subCategories"] as? [AnyObject] {
                                guard ShopViewController.subcategoryNames[name] != nil else {
                                    ShopViewController.subcategoryNames[name] = [subcategoryName]
                                    ShopViewController.subsubcategoryNames[name] = [subcategoryName: []]
                                    continue }
                                ShopViewController.subcategoryNames[name]?.append(subcategoryName)
                                
                                // 3rd level category.
                                for subsubcategory in subsubcategories {
                                    if let subsubcategoryName = subsubcategory["name"] as? String{
                                        guard ShopViewController.subsubcategoryNames[name]![subcategoryName] != nil else { ShopViewController.subsubcategoryNames[name]![subcategoryName] = [subsubcategoryName]; continue }
                                        ShopViewController.subsubcategoryNames[name]![subcategoryName]?.append(subsubcategoryName)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            print(ShopViewController.subsubcategoryNames)
            return
        }
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

