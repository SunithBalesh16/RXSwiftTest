//
//  Transaction.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit

class Transaction: Codable {
    
    //MARK: - Intance Variables
    var id = ""
    var date = ""
    var transactionDesc = ""
    var amount =  ""
    var currency =  ""
    
    var postObject : [String:Any] {
        date = Helper.shared.getTimeFromDate(dateString: "\(Date())", currentDateFormat: "yyyy-MM-dd HH:mm:ss ZZZ", requiredDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        return ["date": date, "description": transactionDesc, "amount": amount, "currency": User.shared().currency]
    }
    
    init(dict : [String:Any]) {
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["date"] as? String {
            date = Helper.shared.getTimeFromDate(dateString: temp, currentDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", requiredDateFormat: "MMM dd,yyyy")
        }
        if let temp = dict["description"] as? String {
            transactionDesc = temp
        }
        if let temp = dict["amount"] as? String {
            amount = temp
        }
        if let temp = dict["currency"] as? String {
            amount = amount + Helper.getSymbolForCurrencyCode(code: temp)!
            currency = temp
        }
        
    }
    
    init(desc : String, amount: String) {
        self.transactionDesc = desc
        self.amount = amount
    }
    
}
