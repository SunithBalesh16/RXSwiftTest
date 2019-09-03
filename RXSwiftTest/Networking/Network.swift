//
//  Network.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import Foundation
import ReactiveSwift
import Alamofire

enum RXTestError: Error {
    
    case noInternet
    case responseError
    case requestError
    case genericError
    case dataFetchError
    case loginError
    case dataSaveError
    case databaseError
    case statusCode(Int)
    case customError(String)
    case defaultError(Error)
    
    var localizedDescription: String {
        switch self {
        case .noInternet:
            return "You appear to be offline!"
        case .loginError:
            return "Session expired"
        case .statusCode(let code) :
            switch code {
            case 400 :
                return "Bad Content"
            case 401 :
                return "Unauthorised"
            case 500...599 :
                return "Something went wrong, please try again later."
            default :
                return ""
            }
        case .customError(let errorString) :
            return errorString
        case .defaultError(let error) :
            return error.localizedDescription
        default:
            return "Uh oh, something went wrong"
        }
    }
}

class Network {
    
    static let shared = Network()    
    private init() {}
    
    func makeRequest(request : URLRequest) -> SignalProducer<Data,RXTestError> {
        return SignalProducer({ (observer, lifetime) in
            Alamofire.request(request).responseData(completionHandler: { (responseData) in
                switch responseData.result {
                case .success(let data):
                    if responseData.response?.statusCode == 401 {
                        APIHandler.shared.login().observe(on: UIScheduler()).on(event: {(event) in
                            switch event {
                            case .value(_):
                                observer.sendCompleted()
                            case .failed(let error):
                                observer.send(error: error)
                            default:
                                observer.send(error: RXTestError.genericError)
                            }
                        }).start()
                    } else {
                        observer.send(value: data)
                    }
                case .failure(let error):
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                        observer.send(error: .noInternet)
                    } else {
                        observer.send(error: .genericError)
                    }
                }
            })
        })
    }
    
}
