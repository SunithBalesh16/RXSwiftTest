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
    
    init(dict : [String:Any]) {
        
        if let temp = dict["id"] as? String {
            id = temp
        }
        if let temp = dict["date"] as? String {
            date = Helper.getTimeFromDate(dateString: temp, currentDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", requiredDateFormat: "MMM dd,yyyy")
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
    
}
