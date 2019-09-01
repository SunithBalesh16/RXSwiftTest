//
//  User.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit

class User : Codable {
    
    static let shared = User()
    
    //MARK: - Intance Variables
    var token : String
    var balance : String
    var currency : String
    var loggedIn : Bool
    var transactions : [Transaction]
    
    private init() {
        token = "Bearer nukpymirqrtmykltocgi"
        balance = ""
        currency = ""
        loggedIn = false
        transactions = [Transaction]()
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
        
        self.save()
    }
    
    func save() {
        
        let encodedData = try? JSONEncoder().encode(self)
        if let data = encodedData , let jsonString = String(data: data, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: "CURRENT_USER")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    func getCurrentUser() -> User {
        
        guard let jsonString = UserDefaults.standard.value(forKey: "CURRENT_USER") as? String else {return User.shared}
        guard let jsonData = jsonString.data(using: .utf8) else { return User.shared }
        guard let userObject = try? JSONDecoder().decode(User.self, from: jsonData) else { return User.shared }
        return userObject
        
    }
}
