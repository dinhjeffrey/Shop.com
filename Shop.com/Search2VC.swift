//
//  Search2VC.swift
//  Shop.com
//
//  Created by jeffrey dinh on 7/22/16.
//  Copyright © 2016 sara and jeff. All rights reserved.
//

import UIKit

// To be combined with SearchVC
class Search2VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var recommendation2: UIButton!
    @IBOutlet weak var recommendation3: UIButton!
    @IBOutlet weak var recommendation4: UIButton!
    @IBOutlet weak var didYouMean: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - IBActions
    @IBAction func recommendationPressed(sender: UIButton) {
        recommendationPressed(sender.tag)
    }
    
    // MARK: - Constants and Variables
    static var names = [String]()
    static var imageUrls = [String]()
    private let shopVC = ShopViewController()
    private struct Storyboard {
        static let Cell = "Cell"
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() { 
        super.viewDidLoad()
        // unwraps recommendations from tags downloaded from Imagga API
        activityIndicator.sendSubviewToBack(tableView)
        activityIndicator.startAnimating()
        if let firstRecommendation = Camera.tags?[0], secondRecommendation = Camera.tags?[1], thirdRecommendation = Camera.tags?[2], fourthRecommendation = Camera.tags?[3] {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { [weak weakSelf = self] in
                // call to Shop product API with first recommendation
                weakSelf?.shopVC.products(firstRecommendation) { responseObject, error in
                    if let products = responseObject?["products"] as? [AnyObject] {
                        for product in products {
                            if let imageUrl = product["imageUrl"] as? String, name = product["name"] as? String {
                                Search2VC.imageUrls.append(imageUrl)
                                Search2VC.names.append(name)
                            }
                        }
                    }
                    weakSelf?.activityView.hidden = true
                    weakSelf?.activityIndicator.stopAnimating()
                    weakSelf?.tableView.reloadData()
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    // updates UI
                    weakSelf?.textField.placeholder = firstRecommendation
                    weakSelf?.recommendation2.setTitle(secondRecommendation, forState: .Normal)
                    weakSelf?.recommendation3.setTitle(thirdRecommendation, forState: .Normal)
                    weakSelf?.recommendation4.setTitle(fourthRecommendation, forState: .Normal)
               }
            }
        }
    }
    
    // MARK: - Methods
    private func recommendationPressed(tag: Int) {
        var term = String()
        var placeholder = String()
        if let secondRecommendation = Camera.tags?[1], thirdRecommendation = Camera.tags?[2], fourthRecommendation = Camera.tags?[3] {
            switch tag {
            case 2:
                term = secondRecommendation
                placeholder = (recommendation2.currentTitle)!
            case 3:
                term = thirdRecommendation
                placeholder = (recommendation3.currentTitle)!
            case 4:
                term = fourthRecommendation
                placeholder = (recommendation4.currentTitle)!
            default:
                fatalError("unknown button pressed")
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak weakSelf = self] in
                weakSelf?.activityView.hidden = false
                weakSelf?.activityIndicator.startAnimating()
                // call to Shop product API with recommendation
                weakSelf?.shopVC.products(term) { responseObject, error in
                    Search2VC.imageUrls = []
                    Search2VC.names = []
                    if let products = responseObject?["products"] as? [AnyObject] {
                        for product in products {
                            if let imageUrl = product["imageUrl"] as? String, name = product["name"] as? String {
                                Search2VC.imageUrls.append(imageUrl)
                                Search2VC.names.append(name)
                            }
                        }
                    }
                    weakSelf?.activityView.hidden = true
                    weakSelf?.activityIndicator.stopAnimating()
                    weakSelf?.tableView.reloadData()
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    // updates UI
                    weakSelf?.textField.placeholder = placeholder
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("search2vc tbv count: \(Search2VC.names.count)")
        return Search2VC.names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.Cell, forIndexPath: indexPath)
//        let name = names[indexPath.row]
        cell.textLabel?.text = Search2VC.names[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // code
    }
    

    
}
