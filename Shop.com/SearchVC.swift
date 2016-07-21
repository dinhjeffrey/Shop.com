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
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    var params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = [
        "apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = sched[indexPath.row] as! String
        return cell!
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
    private func products(brand: String) {
        url += "products"
        
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "start": "", // defaults to 0
            "perPage": "", // defaults to 15
            "term": "",
            "categoryId": "",
            "brandId": brand,
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
    private func taxAndShipping(zip: Int, state: String, city: String, country: String, street: String) {
        url += "taxandshipping"
        
        let params = [
            "publisherID": "TEST", // required
            "locale": "en_US", // required
            "prodIds": "749443420", // required
            "quantity": "1", // required
            "zip": zip, // required
            "state": state,
            "city": city,
            "country": country,
            "street": street
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
