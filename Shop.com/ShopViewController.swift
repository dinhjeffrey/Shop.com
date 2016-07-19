//
//  ViewController.swift
//  Shop.com
//
//  Created by jeffrey dinh on 7/17/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
// test

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
    
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    var params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = [
        "apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"
    ]
    
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
    
    private func categories() {
        url += "categories"
        
        Alamofire.request(
            .GET,
            url,
            parameters: params,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    private func products() {
        url += "products"
        
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "start": "", // defaults to 0
            "perPage": "", // defaults to 15
            "term": "",
            "categoryId": "",
            "brandId": "Vans",
            "sellerId": "",
            "priceRangeId": "" // i.e. "[0.0 TO 10.00]"
        ]
        
        Alamofire.request(
            .GET,
            url,
            parameters: params,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    private func taxAndShipping() {
        url += "taxandshipping"
        
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
        
        Alamofire.request(
            .GET,
            url,
            parameters: params,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    private func searchService() {
        let term = "Vans"
        let url = "https://api.shop.com/sites/v1/search/term/\(term)"
        
        let params = [
            "page": "",
            "count": ""
        ]
        
        Alamofire.request(
            .GET,
            url,
            parameters: params,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    private func productService() {
        let prodId = "874694776"
        let url = "https://api.shop.com/stores/v1/products/\(prodId)"
        
        let params = [
            "allperms": "", // "true" or "false"
//            "siteId": "" // not working when enabled
        ]
        
        Alamofire.request(
            .GET,
            url,
            parameters: params,
            headers: headers
            )
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

