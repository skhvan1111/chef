//
//  FridgeViewController.swift
//  Chef
//
//  Created by Dasha Korneichuk on 09.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class FridgeViewController: UITableViewController {
    
    private var fridge: Fridge = Fridge()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                                                                    NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        if Model.shared.fridgeViewController == nil { Model.shared.fridgeViewController = self }
        
        FridgeRequester.loadFridge { (fridge) in
            self.fridge = fridge
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension FridgeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fridge.getProducts().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FridgeCell") as! FridgeViewCell
        let product = self.fridge.getProducts()[indexPath.row]
        cell.productName.text = product.getName()
        cell.productImage.downloadedFrom(product.getImageUrl())
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let product = self.fridge.getProducts()[indexPath.row]
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.fridge.removeProduct(product)
            FridgeRequester.deleteProductFromFridge(product, completion: { (isDeleted) in
                if isDeleted == false { print("ERROR!") }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    })
                }
            })
        }
    }
}

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = UIViewContentMode.ScaleAspectFit) {
        guard let url = NSURL(string: link) else { return }
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            
            self.image = image
            
//            DispatchQueue.main.sync() { () -> Void in
//                self.image = image
//            }
            }.resume()
    }
}