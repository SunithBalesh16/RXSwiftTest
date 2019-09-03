//
//  API.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import Foundation
import Alamofire

struct Endpoint {
    
    private struct Domains {
        static let Dev = "https://interviewer-api.herokuapp.com"
        static let Local = ""
        static let QA = ""
    }
    
    private struct Routes {
        static let Api = ""
    }
    
    private static let Domain = Domains.Dev
    private static let Route = Routes.Api
    private static let BaseURL = Domain + Route
    
    static func login() -> URLRequest? {
        let loginUrlString = BaseURL  + "/login"
        return self.request(url: loginUrlString, method: .POST, requestBody: nil)
    }
    
    static func transactions() -> URLRequest? {
        let transactionsUrlString = BaseURL  + "/transactions"
        return self.request(url: transactionsUrlString, method: .GET, requestBody: nil)
    }
    
    static func balance() -> URLRequest? {
        let balanceUrlString = BaseURL  + "/balance"
        return self.request(url: balanceUrlString, method: .GET, requestBody: nil)
    }
    
    static func spend() -> URLRequest? {
        let spendUrlString = BaseURL  + "/spend"
        return self.request(url: spendUrlString, method: .GET, requestBody: nil)
    }
    
    static func request(url: String, method: RequestMethod, requestBody : [String : Any]?) -> URLRequest? {
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let token = User.shared.getCurrentUser().token
        if token != "" {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method == .POST {
//            guard let body = requestBody else {return nil}
//            let requestBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//            request.httpBody = requestBody
        }
        return request
    }
    
}

enum RequestMethod : String {
    case GET, PUT, POST, DELETE
}
