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
    private var searchActive: Bool  = false
    
    private var checkedProducts: [Product] = []
    
    @IBOutlet weak var productSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.productSearch.delegate = self
        
        
        ProductRequester.getProducts { (products) in
            self.products = products
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
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
        
        FridgeRequester.addProductsToFridge(self.checkedProducts) { (isLoaded) in
            dispatch_async(dispatch_get_main_queue(), {
                if isLoaded == true {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else { print("Error!") }
            })
        }
    }
}

extension ProductsAddViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell") as! ProductViewCell
        let product = self.products[indexPath.row]
        cell.name.text = self.products[indexPath.row].getName()
        cell.product = product
        if isExistProduct(product) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ProductViewCell
        let product = cell.product
        if isExistProduct(product) {
            deleteProduct(product)
            cell.accessoryType = .None
        } else {
            self.checkedProducts.append(product)
            cell.accessoryType = .Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func isExistProduct(product: Product) -> Bool {
        for prod in self.checkedProducts {
            if prod.getId() == product.getId() { return true }
        }
        return false
    }
    
    private func deleteProduct(product: Product) {
        for (index, prod) in self.products.enumerate() {
            if prod.getId() == product.getId() { self.products.removeAtIndex(index) }
        }
    }
}



extension ProductsAddViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ProductRequester.searchProduct(searchText) { (products) in
            self.products = products
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
}
