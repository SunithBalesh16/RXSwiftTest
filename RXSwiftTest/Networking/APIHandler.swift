//
//  APIHandler.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

class APIHandler {
    
    //MARK: - Class Members
    static let shared = APIHandler()
    
    //MARK: - Instance Members
    private var user = User.shared()
    
    private init() {}
    
    //MARK: - Instance Methods
    func login() -> SignalProducer<User,RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            guard let request = Endpoint.login() else {return}
            guard let `self` = self else { return }
            Network.shared.makeRequest(request: request).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    do {
                        let resultDict = try JSONSerialization.jsonObject(with: value, options: .allowFragments) as! [String:AnyObject]
                        self.user.updateUser(dict: resultDict)
                        observer.send(value: self.user)
                    } catch {
                        observer.send(error: RXTestError.genericError)
                    }
                    break
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
    func getTransactions() -> SignalProducer<User, RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            guard let request = Endpoint.transactions() else {return}
            guard let `self` = self else { return }
            Network.shared.makeRequest(request: request).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    guard let transactions = try? JSONSerialization.jsonObject(with: value, options: .allowFragments) as? [[String:Any]] else {return}
                    self.user.transactions = []
                    for transactionDict in transactions {
                        self.user.transactions.insert(Transaction(dict: transactionDict), at: 0)
                    }
                    observer.send(value: self.user)
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
    func makeTransaction(transaction : Transaction) -> SignalProducer<Data,RXTestError> {
        
        return SignalProducer { (observer, lifetime) in
            guard let request = Endpoint.spend(transaction: transaction) else {return}
            Network.shared.makeRequest(request: request).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    observer.send(value: value)
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
    func getBalance() -> SignalProducer<User, RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            guard let request = Endpoint.balance() else {return}
            guard let `self` = self else { return }
            Network.shared.makeRequest(request: request).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    do {
                        let resultDict = try JSONSerialization.jsonObject(with: value, options: .allowFragments) as! [String:AnyObject]
                        self.user.updateUser(dict: resultDict)
                        observer.send(value: self.user)
                    } catch {
                        observer.send(error: RXTestError.genericError)
                    }
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
}
