//
//  PeopleTableViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/23/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class PeopleTableViewController: UITableViewController {
    var totalBill:Double = 0
    var taxAmount:Double = 0
    var tipAmount:Double = 0
    var numPeople:Int = 0
    var everything:Double = 0
    var enableSave:Int = 0
    var ppl = [People]()
    
    //helper functions
    func displayNumOfPpl() {
        for i in stride(from:0,to:numPeople,by:1) {
            let p = People(name: "person"+String(i+1), money: 0)
            ppl.append(p)
        }
    }
    
    func getPplMoneyAmount() -> Double {
        var total = 0.0;
        for i in 0...(ppl.count-1) {
            total += ppl[i].money
        }; return total
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        displayNumOfPpl()
        let total = totalBill
        let r = Double(round(100*total)/100)
        everything = r
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.title = String(format:"$%.02f", everything - getPplMoneyAmount())
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    //reload the table after changes
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        if enableSave == 0 {
            navigationItem.title = String(format:"$%.02f", everything - getPplMoneyAmount())
        } else {
            navigationItem.title = "Done!"
        }
    }
    //date it was made
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let str = formatter.string(from: Date())
        return str
    }
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        let str = formatter.string(from: Date())
        return str
    }
    //adding to database after clicking save
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? PersonDetailsViewController {
            destination.person = ppl[(tableView.indexPathForSelectedRow?.row)!]
            destination.saveStatus = enableSave
            destination.totalAmount = everything - getPplMoneyAmount()
        } else if segue.destination is HomeViewController {
        let t = Transactions(name:[], amount:[])
        for i in 0...numPeople-1 {
            t.name.append(ppl[i].name)
            t.amount.append(String(format: "$%.02f", ppl[i].money))
        }
        
        let date = getCurrentDate()
        let time = getCurrentTime()
        let ref = Database.database().reference(fromURL: "Firebase database URL here")
        let userId = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(userId!).child("transactions").child(time)
        
        var totalPlusTT = 0.0
        for i in 0...ppl.count-1 {
            totalPlusTT += ppl[i].money
        }
        let tb = String(format: "$%.02f", totalPlusTT)
        usersRef.updateChildValues(["name": t.name])
        usersRef.updateChildValues(["amount": t.amount])
        usersRef.updateChildValues(["date": date])
        usersRef.updateChildValues(["bill": tb])
        usersRef.updateChildValues(["timestamp": time])
        }
    }
    //save function
    @objc func save() {
        let leftover = everything - getPplMoneyAmount()
        if leftover < 0 && enableSave == 1 {
            performSegue(withIdentifier: "backHome",
                         sender: self)
        } else if enableSave == 0 && leftover > 0 {
            let alert = UIAlertController(title: "Wait!", message: "You didnt finish paying everything yet!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else if enableSave == 0 && leftover == 0 {
            let alert = UIAlertController(title: "Wait!", message: "Add tax and tip before saving.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    //split the rest of the money to each person with error checking
    @IBAction func splitRest(_ sender: Any) {
        let leftover = everything - getPplMoneyAmount()
        if leftover > 0 && enableSave == 0 {
            let even = leftover / Double(numPeople)
            let e = Double(round(100*even)/100)
            for i in 0...ppl.count-2 {
                ppl[i].money += e
            }
            ppl[ppl.count-1].money = ppl[ppl.count-1].money + (everything - getPplMoneyAmount())
            navigationItem.title = String(format:"$%.02f", everything - getPplMoneyAmount())
            tableView.reloadData()
        } else if leftover == 0 && enableSave == 0 {
            let alert = UIAlertController(title: "Error", message: "Nothing left to split!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Tip and tax already added, click save to save transaction.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    //adding the tip and tax to each person, but cannot change anything except people's names after
    @IBAction func addTipTax(_ sender: Any) {
        let leftover = everything - getPplMoneyAmount()
        if leftover == 0 && enableSave == 0 {
            let alert = UIAlertController(title: "Done editing?", message: "You won't be able to re-edit payments.", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.enableSave += 1
                for i in 0...self.ppl.count-1 {
                    let taxPercent = Double(self.ppl[i].money/self.everything)
                    let x = (self.ppl[i].money + (taxPercent*self.taxAmount)) * (1+self.tipAmount)
                    self.ppl[i].money = Double(round(100*x)/100)
                }
                self.navigationItem.title = "Done!"
                self.tableView.reloadData()
            })
            let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            alert.addAction(yes)
            present(alert, animated: true, completion: nil)
        } else if enableSave == 1 {
            let alert = UIAlertController(title: "Error", message: "Already added tax and tip, click save to save transaction.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Finish paying first!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
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
    
    //TABlE CONFIGURATIONS BELOW
    //-------------------------------------------
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ppl.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell

        // Configure the cell...
        cell.peopleCeil.layer.cornerRadius = 10
        cell.personName.text = ppl[indexPath.row].name
        cell.moneyLabel.text = String(format: "$%.02f", ppl[indexPath.row].money)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = indexPath.row
        performSegue(withIdentifier: "showDetailOfPerson", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
