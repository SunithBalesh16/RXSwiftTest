//
//  UIViewController.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
