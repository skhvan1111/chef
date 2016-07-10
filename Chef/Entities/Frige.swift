//
//  Frige.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation

class Fridge {
    
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


class FridgeMapper {
    class func parseFridge(data: NSData) -> Fridge {
        let parsedData = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let fridgeData = (parsedData as! NSDictionary).valueForKey("fridge")
        if let productsArray = fridgeData?.valueForKey("products") as? NSArray {
            let fridge = Fridge()
            
            for productData in productsArray {
                fridge.add(ProductMapper.parseProduct(productData as! NSDictionary))
            }
            
            return fridge
        } else {
            return Fridge()
        }
    }
}


class FridgeRequester {
    static private let processor: HTTP = HTTPProcessor.shared
    
    class func loadFridge(completion: (Fridge) -> Void) {
        let url = FridgeUrls.getFrige.rawValue
        self.processor.sendRequest(RequestType.GET, url: url, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)"); abort() }
            completion(FridgeMapper.parseFridge(data!))
        }
    }
    
    class func addProductsToFridge(products: [Product], completion: (Bool) -> Void) {
        var productIds: [String] = []
        
        for product in products {
            productIds.append(product.getId())
        }
        
        let jsonIds = try! NSJSONSerialization.dataWithJSONObject(productIds, options: .PrettyPrinted)
        
        let url = FridgeUrls.addToFrige.rawValue
        
        self.processor.sendRequest(RequestType.POST, url: url, data: jsonIds) { (data, error) in
            if error != nil { print("\(error)\n\n\(error?.userInfo)"); completion(false); return }
            if data  != nil { completion(true); return }
            completion(false)
        }
    }
    
    class func deleteProductFromFridge(productId: String, completion: (Bool)->Void) {
        let url = FridgeUrls.deleteProduct.rawValue+productId
        
        self.processor.sendRequest(RequestType.DELETE, url: url, data: NSData()) { (data, error) in
            if error != nil { print("\(error)\n\(error?.userInfo)"); completion(false); return }
            if data  != nil { completion(true); return }
            completion(false)
        }
    }
}


enum FridgeUrls: String {
    case getFrige = "http://52.34.107.168/api/Fridge"
    case addToFrige = "http://52.34.107.168/api/Fridge/products"
    case deleteProduct = "http://52.34.107.168/api/Fridge/products/"
}

