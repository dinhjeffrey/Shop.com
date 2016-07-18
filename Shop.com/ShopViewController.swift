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
    
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    var params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = ["apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"]
    
    @IBAction func categoriesPressed() {
        categories()
    }
    @IBAction func productsPressed() {
        products()
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
            "publisherID": "TEST",
            "locale": "en_US",
            "start": "",
            "perPage": "",
            "term": "",
            "categoryId": "",
            "brandId": "Vans",
            "sellerId": "",
            "priceRangeId": ""
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

