//
//  Product.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation

class Product {
    private let name: String
    private let imageUrl: String
    private let id: String
    
    init(id: String, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
    func getId()       -> String { return self.id       }
    func getName()     -> String { return self.name     }
    func getImageUrl() -> String { return self.imageUrl }
}

class ProductMapper {
    
    // Parse only one product
    class func parseProduct(data: NSData) -> Product {
        let parsedData  = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let productDict = parsedData as! NSDictionary
        
        let id = productDict.valueForKey("id") as! String
        let name = productDict.valueForKey("name") as! String
        let imageUrl = productDict.valueForKey("imageUrl") as! String
        
        return Product(id: id, name: name, imageUrl: imageUrl)
    }
    
    class func parseProduct(dict: NSDictionary) -> Product {
        return Product(
            id:       dict.valueForKey("id") as! String,
            name:     dict.valueForKey("name") as! String,
            imageUrl: dict.valueForKey("imageUrl") as! String)
    }
    
    // Parse collection of products
    class func parseProducts(data: NSData) -> [Product] {
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let parsedProducts = parsedData as! NSArray
        
        var products: [Product] = []
        
        for parsedProduct in parsedProducts {
            let productDict = parsedProduct as! NSDictionary
            
            products.append(Product(
                id: productDict.valueForKey("id") as! String,
                name: productDict.valueForKey("name") as! String,
                imageUrl: productDict.valueForKey("imageUrl") as! String))
            
        }
        
        return products
    }
}


class ProductRequester {
    
    static private let processor: HTTP = HTTPProcessor.shared
    
    class func getProducts(completion: ([Product]) -> Void) {
        
        processor.sendRequest(RequestType.GET, url: ProductUrls.GetAll.rawValue, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)"); abort() }
            
            let products = ProductMapper.parseProducts(data!)
            
            completion(products)
        }
    }
    
    class func getProduct(id: String, completion: (Product) -> Void) {
        let url = ProductUrls.GetWithId.rawValue+id
        processor.sendRequest(RequestType.GET, url: url, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)") }
            
            let product = ProductMapper.parseProduct(data!)
            
            completion(product)
        }
    }
}


enum ProductUrls: String {
    case GetAll = "http://52.34.107.168/api/Products"
    case GetWithId = "http://52.34.107.168/api/Products/"
}
