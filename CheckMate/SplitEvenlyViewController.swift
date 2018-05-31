//
//  SplitEvenlyViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/24/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class SplitEvenlyViewController: UIViewController {
    var amount:Double = 0.0
    var totalBill:Double = 0.0
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var pays: UILabel!
    var numPpl:Int = 0
    var date = ""
    @IBOutlet weak var amountEach: UILabel!
    
    //displaying the amount everyone pays
    override func viewDidLoad() {
        super.viewDidLoad()
        amountEach.text = String(format: "$%.02f", amount)
        amountEach.clipsToBounds = true
        pays.clipsToBounds = true
        amountEach.layer.cornerRadius = 5;
        pays.layer.cornerRadius = 5;
        let path = UIBezierPath(roundedRect: save.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        save.layer.mask = mask
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backHome(_ sender: UIButton) {
        performSegue(withIdentifier: "toHome",
                         sender: self)
    }
    //date when this happens
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
    //send to database to display in past transactions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let t = Transactions(name:[], amount:[])
        for i in 1...numPpl {
            t.name.append("Person" + String(i))
            t.amount.append(amountEach.text!)
        }
        
        let date = getCurrentDate()
        let time = getCurrentTime()
        let ref = Database.database().reference(fromURL: "Firebase Database URL here")
        let userId = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(userId!).child("transactions").child(time)
        
        let tb = String(format: "$%.02f", totalBill)
        
        usersRef.updateChildValues(["name": t.name])
        usersRef.updateChildValues(["amount": t.amount])
        usersRef.updateChildValues(["date": date])
        usersRef.updateChildValues(["bill": tb])
        usersRef.updateChildValues(["timestamp": time])
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

