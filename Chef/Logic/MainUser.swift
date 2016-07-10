//
//  MainUser.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation


class MainUser {
    
    static private let tokenKey: String = "MAIN_USER_TOKEN"
    
    class func saveToken(token: String) {
        NSUserDefaults.standardUserDefaults().setValue(token, forKey: tokenKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func loadToken() -> String? {
        if let token = NSUserDefaults.standardUserDefaults().valueForKey(tokenKey) as? String {
            return token
        }
        else { return nil }
    }
    
    class func registerInService(token: String) {
        let url = "http://52.34.107.168/api/Accounts/login/vk"
        var data = Dictionary<String, String>()
        data["accessToken"] = token
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
        
        let proc = HTTPProcessor()
        
        proc.sendRequest(RequestType.POST, url: url, data: jsonData) { (data, error) in
            print("\(error)\n\(error?.userInfo)")
            print("\(data)")
        }
    }
}