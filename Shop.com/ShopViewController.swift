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
    
    // MARK: - IBActions
    // APN APIs
    @IBAction func categoriesPressed() {
        categories()
    }
    @IBAction func productsPressed() {
        products()
    }
    @IBAction func taxAndShippingPressed() {
        taxAndShipping()
    }
    
    // PUBLIC APIs
    @IBAction func searchServicePressed() {
        searchService()
    }
    @IBAction func productServicePressed() {
        productService()
    }
    
    // method calls alamofire get request and prints JSON response
    private func alamofireRequest(url: String, parameters: [String: String]) {
        Alamofire.request(
            .GET,
            url,
            parameters: parameters,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    // MARK: - APN API methods
    private func categories() {
        let url = self.url + "categories"
        
        alamofireRequest(url, parameters: params)
    }
    
    private func products() {
        let url = self.url + "products"
        
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "start": "", // defaults to 0
            "perPage": "", // defaults to 15
            "term": "",
            "categoryId": "",
            "brandId": "",
            "sellerId": "",
            "priceRangeId": "" // i.e. "[0.0 TO 10.00]"
        ]
        alamofireRequest(url, parameters: params)
    }
    
    private func taxAndShipping() {
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
        alamofireRequest(url, parameters: params)
    }
    
    // MARK: - Public API methods
    private func searchService() {
        let term = "Vans"
        let url = "https://api.shop.com/sites/v1/search/term/\(term)"
        
        let params = [
            "page": "",
            "count": ""
        ]
        alamofireRequest(url, parameters: params)
    }
    
    private func productService() {
        let prodId = "874694776"
        let url = "https://api.shop.com/stores/v1/products/\(prodId)"
        
        let params = [
            "allperms": "", // "true" or "false"
            //            "siteId": "" // not working when enabled. not sure why
        ]
        alamofireRequest(url, parameters: params)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

