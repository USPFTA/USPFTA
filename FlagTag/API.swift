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
    var gameID = 0
    
    var invitations: [[String:AnyObject]] = [[:]]
    
    var currentGame: [String:AnyObject] = [:]
    
    var gameFlags: [[String:AnyObject]] = [[:]]
    
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
            
            if let dataInfo = responseInfo["invitations"] as? [[String:AnyObject]] {
                
                self.invitations = dataInfo
                
            }
            
        })
        
    }
    
    func acceptInvitation(id: Int, invitation: [String:AnyObject]) {
        
        let inviter_id = invitation["inviter_id"] as Int
        let invited_id = invitation["invited_id"] as Int
        self.gameID = invitation["game_id"] as Int
        let invitation_id = invitation["id"] as Int
        
        println("\(inviter_id), \(invited_id), \(self.gameID), \(invitation_id)")
        
        let options: [String:AnyObject] = [
            "endpoint" : "invitations/\(invitation_id)/accept",
            "method" : "POST",
            "body" : [
                
                "invitation" : ["inviter_id" : inviter_id, "invited_id" : invited_id, "game_id" : self.gameID]
                
            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
//            println("response")
//            println(responseInfo)
            
            if let dataInfo = responseInfo["game"] as? [String:AnyObject] {
                
                println(dataInfo)
                
                self.currentGame = dataInfo
                // save to NSUserDefaults
                let defaults = NSUserDefaults.standardUserDefaults()
                let lat:String = dataInfo["center_lat"] as String
                let lon:String = dataInfo["center_long"] as String
                let endTime:String = dataInfo["ends_at"] as String
                let radius:String = dataInfo["radius"] as String
                defaults.setObject(lat, forKey: "currentGameLat")
                defaults.setObject(lon, forKey: "currentGameLon")
                defaults.setObject(endTime, forKey: "currentGameEndTime")
                defaults.setObject(radius, forKey: "currentGameRadius")
                defaults.synchronize()
                
            }
            
//            if let dataInfo = responseInfo["user"] as? [String:AnyObject] {
//                
//                // TODO: save id in NSUserDefaults
//                
//                self.id = dataInfo["id"] as Int
//                println(self.id)
//                
//                self.token = dataInfo["authentication_token"] as? String
//                
//            }
            
            // call getInvitations
//            self.getInvitations(id)
            
        })
        
    }
    
    func declineInvitation(id: Int, invitation: [String:AnyObject]) {
        
        let inviter_id = invitation["inviter_id"] as Int
        let invited_id = invitation["invited_id"] as Int
        let game_id = invitation["game_id"] as Int
        let invitation_id = invitation["id"] as Int
        
        println("\(inviter_id), \(invited_id), \(game_id), \(invitation_id)")
        
        let options: [String:AnyObject] = [
            "endpoint" : "invitations/\(invitation_id)/decline",
            "method" : "POST",
            "body" : [
                
                "invitation" : ["inviter_id" : inviter_id, "invited_id" : invited_id, "game_id" : game_id]
                
            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
            println("response")
            println(responseInfo)
            
            //            if let dataInfo = responseInfo["user"] as? [String:AnyObject] {
            //
            //                // TODO: save id in NSUserDefaults
            //
            //                self.id = dataInfo["id"] as Int
            //                println(self.id)
            //
            //                self.token = dataInfo["authentication_token"] as? String
            //
            //            }
            
            // call getInvitations
//            self.getInvitations(id)
            
        })
        
    }
    
    func placeFlag(objective: String, lat: Double, lon: Double) {
        
        let options: [String:AnyObject] = [
            "endpoint" : "flags",
            "method" : "POST",
            "body" : [
                
                "flag": [ "name" : objective, "flag_lat" : lat, "flag_long" : lon ]
                
            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            // set token
            println(responseInfo)
            
        })
    }
    
    func listFlags() {
        
        let options: [String:AnyObject] = [
            "endpoint" : "games/\(self.gameID)",
            "method" : "GET"
//            "body" : [
//                
//                "flag": [ "name" : objective, "flag_lat" : lat, "flag_long" : lon ]
//                
//            ]
            
        ]
        
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo) -> () in
            
            println(responseInfo)
            
            if let dataInfo = responseInfo["flags"] as? [[String:AnyObject]] {
                
                println(dataInfo)
                self.gameFlags = dataInfo
                
            }
            
        })
        
    }
    
}

typealias ResponseBlock = (responseInfo: [String: AnyObject]) -> ()

class APIRequest {
    
    class func requestWithEndpoint(endpoint: String, method: String, completion: ResponseBlock) {
        
        var options = [
        
            "endpoint" : endpoint,
            "method" : method
            
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