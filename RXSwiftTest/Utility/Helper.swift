//
//  Helper.swift
//  RXSwiftTest
//
//  Created by Sunith B on 30/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    /**
     *  Method take in currency code and returns symbol for respective currency code
     *
     *  @params String
     *
     *  @return String
     */
    class func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    /**
     *  Method takes in a date string of a particular format and converts it to required format
     *
     *  @params String,String,String
     *
     *  @return String
     */
    class func getTimeFromDate(dateString : String , currentDateFormat : String , requiredDateFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentDateFormat
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = requiredDateFormat
        let formattedDate = dateFormatter.string(from: dateObj!)
        return formattedDate
    }
    
    /**
     *  Method to show alerts
     *
     *  @params UIViewController,String
     */
    class func showAlert(viewController: UIViewController, title: String) {
        
        let alertController = UIAlertController(title: "", message: title, preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    /**
     *  Method to return tool bar
     *
     *  @params Selector,UIViewController,String
     */
    class func getToolBar(selector : Selector, viewController : UIViewController , title : String) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
        toolBar.tintColor = UIColor.blue
        let doneBtn = UIBarButtonItem(title: "Next", style: .plain, target: viewController, action: selector)
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,doneBtn], animated: false)
        return toolBar
    }
    
    /**
     *  Method to add shadow to Layer
     *
     *  @params CALayer,Float,CGSize,CGSize,CGColor
     */
    class func addShadow(forLayer layer : CALayer , opacity : Float , offset : CGSize , radius : CGFloat , color: UIColor) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
    }
    
}
