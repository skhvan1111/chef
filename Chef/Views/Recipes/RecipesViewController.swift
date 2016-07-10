//
//  RecipesViewController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class RecipesViewController: UITableViewController {

    private var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Model.shared.recipesViewController = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        RecipeRequester.loadRecipes { (recipes) in
            self.recipes = recipes
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension RecipesViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell") as! RecipeViewCell
        let recipe = self.recipes[indexPath.row]
        cell.recipeName.text = recipe.getName()
        if recipe.getCountOfOutProducts() > 0 {
            cell.recipeProductsLost.text = "Нехватает продуктов: \(recipe.getCountOfOutProducts())"
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("RecipeInfo") as! RecipeStepsController
        vc.setUpRecipe(self.recipes[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
