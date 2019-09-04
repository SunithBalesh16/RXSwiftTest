//
//  TransactionsViewController.swift
//  RXSwiftTest
//
//  Created by Sunith B on 27/08/19.
//  Copyright © 2019 Sunith B. All rights reserved.
//

import UIKit
import ReactiveSwift

class TransactionsViewController: UIViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case addTransactionSegue
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var transactionTableView: UITableView! {
        didSet {
            transactionTableView.tableFooterView = UIView(frame: CGRect.zero)
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            transactionTableView.refreshControl = refreshControl
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
            return User.shared()
        }
    }
    private lazy var loadingVC = LoadingVC()

    //MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignals()
        observeChanges()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segueIdentifierForSegue(segue: segue) {
        case .addTransactionSegue:
            guard let destination = segue.destination as? AddTransactionVC else {return}
            destination.delegate = self
        }
    }
    
    //MARK: - Private Methods
    private func setupSignals() {
        add(loadingVC)
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
            self.loadingVC.remove()
            switch event {
            case .value(_):
                self.updateViews()
            case .failed(let error):
                self.showAlert(title: "", message: error.localizedDescription)
            default:
                break
            }
        }).start()
    }
    
    fileprivate func updateViews() {
        self.balanceLabel.text = "Balance : \(user.balance)"
        self.transactionTableView.reloadData()
    }
    
    
    //MARK: - User Interactions
    @IBAction func addTransaction(_ sender: Any) {
        performSegueWithIdentifier(segueIdentifier: .addTransactionSegue, sender: self)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        add(loadingVC)
        userSignal = apiHandler.getBalance().then(apiHandler.getTransactions())
        observeChanges()
        refreshControl.endRefreshing()
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

extension TransactionsViewController : AddTransactionDelegate {
    
    func didAddTransaction() {
        userSignal = apiHandler.getTransactions().then(apiHandler.getBalance())
        observeChanges()
    }
    
}

