//
//  API.swift
//  RailsRequest
//
//  Created by Mollie on 2/17/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import Foundation

let API_URL = "https://tiy-hackathon.herokuapp.com/"

private let _currentUser = User()

class User {
    
    var id = 6 // FIXME: change this later, by using NSUserDefaults
    
    var token: String? {
        
        didSet {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(token, forKey: "token")
            defaults.synchronize()
            
        }
        
    }
    
    init() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        token = defaults.objectForKey("token") as? String
        
    }
    
    class func currentUser() -> User { return _currentUser }
    
    func register(username: String, email: String, password: String) {
        
        let options: [String:AnyObject] = [
            "endpoint" : "users",
            "method" : "POST",
            "body" : [
                
                "user" : [ "username" : username, "email" : email, "password" : password ]
                
            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
            println(responseInfo)
            
            if let dataInfo = responseInfo["user"] as? [String:AnyObject] {
                
                // TODO: save id in NSUserDefaults
                
                self.id = dataInfo["id"] as Int
                println(self.id)
            
                self.token = dataInfo["authentication_token"] as? String
                
            }
            
        })
        
    }
    
    func signIn(email: String, password: String) {
        
        let options: [String:AnyObject] = [
            "endpoint" : "users/sign_in",
            "method" : "POST",
            "body" : [
                
                "user" : [ "email" : email, "password" : password ]
                
            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
            println(responseInfo)
            
            if let dataInfo = responseInfo["user"] as? [String:AnyObject] {
                
                // TODO: save id in NSUserDefaults
                
                self.id = dataInfo["id"] as Int
                println(self.id)
            
                self.token = dataInfo["authentication_token"] as? String
                
            }
            
        })
        
    }
    
    func getInvitations(id: Int) {
        
        println("invitations/users/\(User.currentUser().id)")
        
        let options: [String:AnyObject] = [
            "endpoint" : "invitations/users/\(User.currentUser().id)",
            "method" : "GET"
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
            println(responseInfo)
            
            if let dataInfo = responseInfo["invitations"] as? [String:AnyObject] {
                
                println(dataInfo)
                
            }
            
        })
        
    }
    
}

typealias ResponseBlock = (responseInfo: [String: AnyObject]) -> ()

class APIRequest {
    
    class func requestWithEndpoint(endpoint: String, method: String, completion: ResponseBlock) {
        
        var options = [
        
            "endpoint" : endpoint,
            "method" : method,
            "body" : [
            
                "user" : ["authentication_token" : User.currentUser().token!]
            
            ]
            
        ] as [String:AnyObject]
        
        requestWithOptions(options, andCompletion: completion)
        
    }
    
    class func requestWithOptions(options: [String: AnyObject], andCompletion completion: ResponseBlock) {
        
        var urlString = API_URL + (options["endpoint"] as String)
        
        if let token = User.currentUser().token {
            
            urlString += "?authentication-token=" + token
            
        }
            
        var url = NSURL(string: urlString)
        
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = options["method"] as String
        
        if let bodyInfo = options["body"] as? [String:AnyObject] {
        
            let requestData = NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions.allZeros, error: nil)
            
            let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
            
            let postLength = "\(jsonString!.length)"
            
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = postData
            
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil {
                
                let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String:AnyObject]
                
                completion(responseInfo: json)
                
            } else {
                
                println(error)
                
            }
            
        }
        
    }
    
}