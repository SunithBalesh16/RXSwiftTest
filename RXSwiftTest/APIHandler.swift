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
    private var user = User.shared.getCurrentUser()
    
    private init() {}
    
    //MARK: - Instance Methods
    func login() -> SignalProducer<Data,RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            guard let `self` = self else { return }
            Network.shared.makeRequest(request: Endpoint.login()!).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    do {
                        let resultDict = try JSONSerialization.jsonObject(with: value, options: .allowFragments) as! [String:AnyObject]
                        self.user.updateUser(dict: resultDict)
                    } catch {
                        observer.send(error: RXTestError.genericError)
                    }
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).then(self.getBalance()).then(self.getTransactions()).start()
        }
        
    }
    
    func getTransactions() -> SignalProducer<Data, RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            Network.shared.makeRequest(request: Endpoint.transactions()!).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    guard let transactions = try? JSONSerialization.jsonObject(with: value, options: .allowFragments) as? [[String:Any]] else {return}
                    self?.user.transactions = []
                    print("Transactions")
                    for transactionDict in transactions {
                        self?.user.transactions.insert(Transaction(dict: transactionDict), at: 0)
                    }
                    self?.user.save()
                    observer.sendCompleted()
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
    func makeTransaction() -> SignalProducer<Data,RXTestError> {
        
        return SignalProducer { (observer, lifetime) in
            Network.shared.makeRequest(request: Endpoint.spend()!).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    observer.send(value: value)
                    observer.sendCompleted()
                case .failed(let error):
                    observer.send(error: error)
                default:
                    observer.send(error: RXTestError.genericError)
                }
            }).start()
        }
        
    }
    
    func getBalance() -> SignalProducer<Data, RXTestError> {
        
        return SignalProducer { [weak self] (observer, lifetime) in
            Network.shared.makeRequest(request: Endpoint.balance()!).observe(on: UIScheduler()).on(event: {(event) in
                switch event {
                case .value(let value):
                    do {
                        let resultDict = try JSONSerialization.jsonObject(with: value, options: .allowFragments) as! [String:AnyObject]
                        print("Balance")
                        self?.user.updateUser(dict: resultDict)
                        observer.sendCompleted()
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
