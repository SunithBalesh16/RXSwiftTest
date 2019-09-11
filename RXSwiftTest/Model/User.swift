//
//  User.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit
import ReactiveSwift

class User : Codable {
    
    private static var privateShared : User?

    //MARK: - Intance Variables
    var token : String
    var balance : String
    var currency : String
    var loggedIn : Bool
    var transactions : [Transaction]
    
    private init() {
        token = ""
        balance = ""
        currency = ""
        loggedIn = false
        transactions = [Transaction]()
    }
    
    class func shared() -> User { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = User()
            return privateShared!
        }
        return uwShared
    }
    
    class func clearUser() {
        privateShared = nil
    }
    
    //MARK: - Member functions
    func updateUser(dict : [String:Any]) {
        
        if let temp = dict["token"] as? String {
            token = "Bearer " + temp
        }
        if let temp = dict["balance"] as? String {
            balance = temp
        }
        if let temp = dict["currency"] as? String {
            currency = temp
        }
        loggedIn = true
        
    }
    
}
