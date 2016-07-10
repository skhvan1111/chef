//
//  Recipe.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation


class Recipe {
    private let name: String
    private let description: String
    private let imageUrl: String
    private let ingridients: [Product]
    private let steps: [Step]
    
    init(name: String, descr: String, imgUrl: String, ingridients: [Product], steps: [Step]) {
        self.name = name
        self.description = descr
        self.imageUrl = imgUrl
        self.ingridients = ingridients
        self.steps = steps
    }
    
    func getCountOfOutProducts() -> Int {
        var count = 0
        for prod in ingridients {
            if prod.isOutInFridge() {
                count += 1
            }
        }
        return count
    }
    
    func getName() -> String { return self.name }
}


class RecipeMapper {
    class func parseRecipe(data: NSData) -> Recipe {
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let recipreDict = parsedData as! NSDictionary
        
        let name = recipreDict.valueForKey("name") as! String
        let description = recipreDict.valueForKey("description") as! String
        let imageUrl = recipreDict.valueForKey("imageUrl") as! String
        
        var ingridients: [Product] = []
        
        for product in recipreDict.valueForKey("ingredients") as! NSArray {
            ingridients.append(ProductMapper.parseProduct(product as! NSDictionary))
        }
        
        var steps: [Step] = []
        
        for step in recipreDict.valueForKey("steps") as! NSArray {
            steps.append(StepMapper.parseStep(step as! NSDictionary))
        }
        
        return Recipe(
            name: name,
            descr: description,
            imgUrl: imageUrl,
            ingridients: ingridients,
            steps: steps)
    }
    
    class func parseRecipe(dict: NSDictionary) -> Recipe {
        
        let name = dict.valueForKey("name") as! String
        let description = dict.valueForKey("description") as! String
        let imageUrl = dict.valueForKey("imageUrl") as! String
        
        var ingridients: [Product] = []
        
        for product in dict.valueForKey("ingredients") as! NSArray {
            ingridients.append(ProductMapper.parseProduct(product as! NSDictionary))
        }
        
        var steps: [Step] = []
        
        for step in dict.valueForKey("steps") as! NSArray {
            steps.append(StepMapper.parseStep(step as! NSDictionary))
        }
        
        return Recipe(
            name: name,
            descr: description,
            imgUrl: imageUrl,
            ingridients: ingridients,
            steps: steps)
    }
    
    class func parseRecipes(data: NSData) -> [Recipe] {
        var recipes: [Recipe] = []
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let recipesArray = parsedData as! NSArray
        
        for recipeData in recipesArray {
            let recipeDict = recipeData as! NSDictionary
            recipes.append(parseRecipe(recipeDict))
        }
        
        return recipes
    }
}


class RecipeRequester {
    
    static private let proc = HTTPProcessor()
    
    class func loadRecipes(completion: ([Recipe]) -> Void) {
        proc.sendRequest(RequestType.GET, url: RecipeUrls.mainGet.rawValue, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\(error?.userInfo)") }
            
            let recipes = RecipeMapper.parseRecipes(data!)
            
            completion(recipes)
        }
    }
}

enum RecipeUrls: String {
    case mainGet = "http://52.34.107.168/api/Recipes"
}