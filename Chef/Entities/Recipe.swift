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
}


class RecipeMapper {
    class func parseRecipe(data: NSData) -> Recipe {
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let recipreDict = parsedData as! NSDictionary
        
        let name = recipreDict.valueForKey("name") as! String
        let description = recipreDict.valueForKey("description") as! String
        let imageUrl = recipreDict.valueForKey("imageUrl") as! String
        
        var ingridients: [Product] = []
        
        for product in recipreDict.valueForKey("ingridients") as! NSArray {
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
}