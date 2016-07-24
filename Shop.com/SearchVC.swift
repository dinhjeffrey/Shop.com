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
   
    @IBOutlet weak var tableview: UITableView!
    
    var url = "https://api.shop.com/AffiliatePublisherNetwork/v1/"
    var params = [
        "publisherID": "TEST",
        "locale": "en_US",
        ]
    let headers = [
        "apikey": "l7xxe5c08ba7f05d41d3b8ee3bbb481d30d5"
    ]

    var categorycount = 0
    var categorynames = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorycount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = categorynames[indexPath.row] as! String
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
                if let JSON = response.result.value {
                    var i = 0
                    let x = JSON[0] as! NSDictionary
                    for (key, value) in x{
                        print(key)
                        /*
                        self.categorycount++
                        self.categorynames.append(value[i]["name"]!!)
                        print(self.categorynames)
                        self.tableview.reloadData()
                        i++
                        print(i)
 */
                    }
 
                }
        }
        
        print("reloading data...")
        dispatch_async(dispatch_get_main_queue()) {
            self.tableview.reloadData()
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
            parameters: params as! [String : AnyObject],
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
