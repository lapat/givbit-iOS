//
//  TransactionsVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/26/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class TransactionsVC: UIViewController {
    
    @IBOutlet weak var transactionsTableView: UITableView!
    var transactions = [GBTransaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // show bottom bar
        self.tabBarController?.tabBar.isHidden = false
        print("viewDidAppear")
        // Do any additional setup after loading the view.
        
        // get the transactions from firestore
        SVProgressHUD.show()
        FirestoreHelper.sharedInstnace.getTransactionsForUser(uuid: (Auth.auth().currentUser?.uid)!) { (transactions, status) in
            SVProgressHUD.dismiss()
            if status{
                print("got transactions")
                self.transactions = transactions
                self.transactionsTableView.reloadData()
            }else{
                print("error could not get transactions")
                // ERROR happened
                // ... handle it
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    // called when the user taps vendor button
    @IBAction func didTapOnVendorButtton(sender: NSObject){
        // check if the vendor is present in the cache of database inside firebase
        FirestoreHelper.sharedInstnace.getUserVendorInfo(fromCache: true) { (info, error) in
            if error != nil{
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Sorry, something went wrong. Please try again.", andTitle: "Error")
            }else{
                if info != nil{
                    self.performSegue(withIdentifier: "vendorWelcomeSegue", sender: self)
                }else{
                    self.performSegue(withIdentifier: "vendorCreateInvoiceSegue", sender: self)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TransactionsVC: UITableViewDelegate{
    
}

extension TransactionsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction-cell") as! GBTransactionTVC
        if (transactions[indexPath.row] != nil){
            cell.populateCellWithGBTransanctions(transaction: transactions[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "transaction-label-cell")?.contentView
        return view
    }
    
    
}
