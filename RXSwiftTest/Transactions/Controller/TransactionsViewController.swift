//
//  TransactionsViewController.swift
//  RXSwiftTest
//
//  Created by Sunith B on 27/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit
import ReactiveSwift

class TransactionsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var transactionTableView: UITableView! {
        didSet {
            transactionTableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var userSignal: SignalProducer<Data, RXTestError>?
    private var balanceSignal: SignalProducer<Data, RXTestError>?
    private var inProgressSignal: Disposable?
    
    private var apiHandler = APIHandler.shared
    private var user : User {
        get {
            return User.shared.getCurrentUser()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignals()
        observeChanges()
        // Do any additional setup after loading the view.
    }
    
    private func setupSignals() {
        if user.token != "" {
            userSignal = apiHandler.getBalance().then(apiHandler.getTransactions())
        } else {
            userSignal = apiHandler.login()
        }
    }
    
    private func observeChanges() {
        guard let signal = userSignal else {
            return
        }
        inProgressSignal?.dispose()
        inProgressSignal = signal.observe(on: UIScheduler()).on(event: { [weak self] (event) in
            guard let `self` = self else { return }
            switch event {
            case .value(_):
                self.updateViews()
            case .failed(let error):
                self.showAlert(title: "", message: error.localizedDescription)
            case .completed:
                self.updateViews()
            default:
                break
            }
        }).start()
    }
    
    fileprivate func updateViews() {
        self.balanceLabel.text = "Balance : \(user.balance)"
        self.transactionTableView.reloadData()
    }

}

extension TransactionsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as?  TransactionCell else {return UITableViewCell()}
        let transaction = user.transactions[indexPath.row]
        cell.amountLabel.text = transaction.amount
        cell.descriptionLabel.text = transaction.transactionDesc
        cell.dateLabel.text = transaction.date
        return cell
    }
    
}

