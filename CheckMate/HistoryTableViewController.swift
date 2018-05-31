//
//  HistoryTableViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/20/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class HistoryTableViewController: UITableViewController {
    var amount:Double = 0
    let ref = Database.database().reference(fromURL: "Firebase Database URL here")
    let userId = Auth.auth().currentUser?.uid
    let transactions = NSMutableArray()
    var name = NSArray()
    var amt = NSArray()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    //loading the account's transactions
    func loadData() {
        let usersRef = ref.child("users").child(userId!).child("transactions")
        usersRef.queryLimited(toLast: 15).observe(.value) { (snapshot) in
            self.transactions.removeAllObjects()
            for child in snapshot.children {
                let child = child as? DataSnapshot
                self.transactions.insert(child?.value, at:0)
                self.table.reloadData()
            }
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        //after logout go login controller
        //this only dismisses screen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(vc!, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //TABLE CONFIGURATIONS BELOW
    //-------------------------------------
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let t = self.transactions[indexPath.row] as! [String: AnyObject]
        print(t)
        cell.cellLayer.layer.cornerRadius = 10
        cell.date.text = t["date"] as? String
        cell.bill.text = t["bill"] as? String

        return cell
    }
    //sending data to the next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is TransactionsViewController {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as? TransactionsViewController
                let t = self.transactions[indexPath.row] as! [String: AnyObject]
                vc?.name = (t["name"] as? NSArray)!
                vc?.amount = (t["amount"] as? NSArray)!
            }
        }
    }
    
    func toTrans(_ sender: Any) {
        performSegue(withIdentifier: "toTrans",
                         sender: self)
    }
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let t = self.transactions[indexPath.row] as! [String: AnyObject]
            let date = t["timestamp"] as! String
            
            // delete data from firebase
            
            let usersRef = ref.child("users").child(userId!).child("transactions").child(date)
            usersRef.removeValue()
            table.reloadData()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


    
    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

