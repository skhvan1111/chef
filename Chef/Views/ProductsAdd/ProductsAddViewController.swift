//
//  ProductsAddViewController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class ProductsAddViewController: UITableViewController {

    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        ProductRequester.getProducts { (products) in
            
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadToFridge(sender: AnyObject) {
        print("Loading...")
        let activIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let itemButton = UIBarButtonItem.init(customView: activIndicator)
        self.navigationItem.rightBarButtonItem = itemButton
        activIndicator.startAnimating()
    }
}

//extension ProductsAddViewController: UITableViewDelegate {
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.products.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("productCell")
//        return cell!
//    }
//}

//extension ProductsAddViewController: UITableViewDataSource {
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.products.count
//    }
//}
