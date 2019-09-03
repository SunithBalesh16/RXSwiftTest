//
//  AddTransactionVC.swift
//  RXSwiftTest
//
//  Created by Sunith B on 03/09/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit

protocol AddTransactionDelegate : class {
    
    func didAddTransaction()
    
}

class AddTransactionVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            //            descriptionTextView.inputAccessoryView = Helper.getToolBar(selector: #selector(AddTransactionVC.dismissKeyboard), viewController: self, title: "Done")
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            //            amountTextField.inputAccessoryView = Helper.getToolBar(selector: #selector(AddTransactionVC.dismissKeyboard), viewController: self, title: "Done")
        }
    }
    
    //MARK: - Instance Members
    private var user = User.shared.getCurrentUser()
    weak var delegate : AddTransactionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.addShadow(forLayer: headerView.layer, opacity: 0.5, offset: CGSize(width: 0, height: 3.0), radius: 2, color: UIColor.darkGray)
        balanceLabel.text = "Balance : " + user.balance
        // Do any additional setup after loading the view.
    }
    
    //MARK: - User Interactions
    @IBAction func spend(_ sender: Any) {
        
        if amountTextField.text! == "" {
            Helper.showAlert(viewController: self, title: "Please enter valid amount")
            return
        }
        
        if descriptionTextView.text! == "" {
            Helper.showAlert(viewController: self, title: "Please enter valid description")
            return
        }
        
        guard let amount = Float(amountTextField.text!) , let balance = Float(user.balance) else { return }
        if amount > balance {
            Helper.showAlert(viewController: self, title: "You have exceeded available balance")
            return
        }
        
        let date = Helper.getTimeFromDate(dateString: "\(Date())", currentDateFormat: "yyyy-MM-dd HH:mm:ss ZZZ", requiredDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        let requestDict : [String:Any] = ["date": date,"description": descriptionTextView.text!,"amount": amountTextField.text!,"currency":user.currency]
        activityIndicator.startAnimating()
        
//        APIHandler.shared.makeTransaction(requestDict: )
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Private Methods
    private func dismissKeyboard() {
        
        amountTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.amountTextField.resignFirstResponder()
        self.descriptionTextView.resignFirstResponder()
    }
    
    
}

extension AddTransactionVC : UITextViewDelegate , UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let oldText = textView.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: text)
        if newText.count >= 10 {
            return false
        }
        return true
    }
    
    
}
