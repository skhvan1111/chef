//
//  Frige.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation

class Frige {
    
    private var products: [Product] = []
    
    func add(product: Product) {
        self.products.append(product)
    }
    
    func getProducts() -> [Product] {
        return self.products
    }
    
    func deleteProject(id: String) {
        for (index, product) in products.enumerate() {
            if product.getId() == id {
                products.removeAtIndex(index)
            }
        }
    }
}


class FrigeMapper {
    class func parseFrige(data: NSData) -> Frige {
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        if let productsArray = (parsedData as! NSDictionary).valueForKey("products") as? NSArray {
            let frige = Frige()
            
            for productData in productsArray {
                frige.add(ProductMapper.parseProduct(productData as! NSDictionary))
            }
            
            return frige
        } else {
            return Frige()
        }
    }
}


class FrigeRequester {
    static private let processor: HTTP = HTTPProcessor.shared
    
    class func loadFrige(completion: (Frige) -> Void) {
        let url = FrigeUrls.getFrige.rawValue
        self.processor.sendRequest(RequestType.GET, url: url, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)"); abort() }
            completion(FrigeMapper.parseFrige(data!))
        }
    }
    
    class func addProductsToFrige(products: [Product], completion: (Bool) -> Void) {
        var productIds: [String] = []
        
        for product in products {
            productIds.append(product.getId())
        }
        
        var productsIdsDict = Dictionary<String, [String]>()
        productsIdsDict["productIds"] = productIds
        
        let jsonIds = try! NSJSONSerialization.dataWithJSONObject(productsIdsDict, options: .PrettyPrinted)
        
        let url = FrigeUrls.addToFrige.rawValue
        
        self.processor.sendRequest(RequestType.POST, url: url, data: jsonIds) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)"); completion(false); return }
            if data  != nil { completion(true); return }
            completion(false)
        }
    }
    
    class func deleteProductFromFrige(productId: String, completion: (Bool)->Void) {
        let url = FrigeUrls.deleteProduct.rawValue+productId
        
        self.processor.sendRequest(RequestType.DELETE, url: url, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\(error?.userInfo)"); completion(false); return }
            if data  != nil { completion(true); return }
            completion(false)
        }
    }
}


enum FrigeUrls: String {
    case getFrige = "http://52.34.107.168/api/Fridge"
    case addToFrige = "http://52.34.107.168/api/Fridge/products"
    case deleteProduct = "http://52.34.107.168/api/Fridge/products/"
}

