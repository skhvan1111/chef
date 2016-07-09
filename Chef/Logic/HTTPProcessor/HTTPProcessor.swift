//
//  HTTPProcessor.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation

protocol HTTP {
    func sendRequest(type: RequestType, url: String, data: NSData, compl: (NSData?, NSError?) -> Void)
}

class HTTPProcessor: HTTP {
    
    static let shared = HTTPProcessor()
    
    private let session: NSURLSession
    private let sessionConfiguration: NSURLSessionConfiguration
    
    init() {
        self.sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: self.sessionConfiguration)
    }
    
    
    func sendRequest(type: RequestType, url: String, data: NSData, compl: (NSData?, NSError?) -> Void) {
        
        let uri = NSURL(string: url+"?access_token=\(MainUser.loadToken()!)")!
        
        let req = NSMutableURLRequest(URL: uri)
        
        if type == .GET    { req.HTTPMethod = "GET"    }
        if type == .POST   { req.HTTPMethod = "POST"   }
        if type == .DELETE { req.HTTPMethod = "DELETE" }
        
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        req.HTTPBody = data
        
        let task = session.dataTaskWithRequest(req) { (data, response, error) in
            if error != nil { compl(nil, error) }
            if data  != nil {
                compl(data, nil)
            }
        }
        
        task.resume()
    }
    
    
    
}

enum RequestType {
    case GET
    case POST
    case DELETE
}