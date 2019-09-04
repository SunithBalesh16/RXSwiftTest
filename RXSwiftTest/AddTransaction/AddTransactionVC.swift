//
//  AddTransactionVC.swift
//  RXSwiftTest
//
//  Created by Sunith B on 03/09/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol AddTransactionDelegate : class {
    
    func didAddTransaction()
    
}

class AddTransactionVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    
    //MARK: - Instance Members
    private var user = User.shared()
    weak var delegate : AddTransactionDelegate?
    private var addTransactionSignal: SignalProducer<Data, RXTestError>?
    private var inProgressSignal: Disposable?
    private lazy var loadingVC = LoadingVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - User Interactions
    @IBAction func spend(_ sender: UIButton) {
        
        guard let amountText = amountTextField.text else {return}
        guard let description = descriptionTextView.text else {return}
        
        if amountText.isEmpty {
            Helper.showAlert(viewController: self, title: "Please enter valid amount")
            return
        }
        
        if description.isEmpty {
            Helper.showAlert(viewController: self, title: "Please enter valid description")
            return
        }
        
        guard let amount = Float(amountText), let balance = Float(user.balance) else { return }
        if amount > balance {
            Helper.showAlert(viewController: self, title: "You have exceeded available balance")
            return
        }
        add(loadingVC)
        addTransactionSignal = APIHandler.shared.makeTransaction(transaction: Transaction(desc: description, amount: amountText))
        observeChanges()
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        Helper.addShadow(forLayer: headerView.layer, opacity: 0.5, offset: CGSize(width: 0, height: 3.0), radius: 2, color: UIColor.darkGray)
        balanceLabel.text = "Balance : " + user.balance
    }
    
    private func dismissKeyboard() {
        amountTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    private func observeChanges() {
        guard let signal = addTransactionSignal else {
            return
        }
        inProgressSignal?.dispose()
        inProgressSignal = signal.observe(on: UIScheduler()).on(event: { [weak self] (event) in
            guard let `self` = self else { return }
            self.loadingVC.remove()
            switch event {
            case .value(_):
                guard let delegate = self.delegate else { return }
                delegate.didAddTransaction()
                self.navigationController?.popViewController(animated: true)
                break
            case .failed(let error):
                self.showAlert(title: "", message: error.localizedDescription)
            default:
                break
            }
        }).start()
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
        if let dotIndex = newText.firstIndex(of: ".") {
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


