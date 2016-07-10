//
//  AuthorizeUser.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation


class AuthorizeUser {
    static private let proc = HTTPProcessor()
    static private let url = "http://52.34.107.168/api/Accounts"
    
    class func authrorize(login: String, pass: String, completion: (Bool) -> Void) {
        var data = Dictionary<String, String>()
        data["username"] = login
        data["password"] = pass
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
        
        proc.sendRequest(RequestType.POST, url: url+"/login", data: jsonData) { (data, error) in
            
            let jsonParsed = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let error = jsonParsed.valueForKey("error") as? NSDictionary {
                print("\(error)")
                completion(false)
                return
            }
            
            if let user = jsonParsed as? NSDictionary {
                MainUser.saveToken(jsonParsed.valueForKey("id") as! String)
                print("ACCESS TOKEN RETREIVED: \(jsonParsed.valueForKey("id"))")
                completion(true)
                return
            }
        }
    }
    
    class func registerUser(login: String, email: String, pass: String, completion: (Bool) -> Void) {
        var data = Dictionary<String, String>()
        data["username"] = login
        data["email"] = email
        data["password"] = pass
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
        
        proc.sendRequest(RequestType.POST, url: url, data: jsonData) { (data, errorServer) in
            let parsedJson = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            
            if let jsonDict = parsedJson as? NSDictionary {
                if let error = jsonDict.valueForKey("error") as? NSDictionary {
                    print("\(error.valueForKey("name"))\n\(error.valueForKey("message"))")
                    completion(false)
                    return
                }
                
                if let username = jsonDict.valueForKey("username") as? String {
                    authrorize(username, pass: pass, completion: { (isAuth) in
                        completion(isAuth)
                    })
                }
            }
            
            
        }
    }
}