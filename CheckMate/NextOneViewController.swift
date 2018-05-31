//
//  NextOneViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/23/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class NextOneViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var percentSlider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    var totalBill=""
    var numPpl:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        taxTextField.delegate = self
        //tap outside to leave keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        splitLabel.clipsToBounds = true
        tipLabel.clipsToBounds = true
        taxLabel.clipsToBounds = true
        taxLabel.layer.cornerRadius = 5;
        tipLabel.layer.cornerRadius = 5;
        splitLabel.layer.cornerRadius = 5;
        nextBtn.layer.cornerRadius = 5;
        let path = UIBezierPath(roundedRect: nextBtn.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        nextBtn.layer.mask = mask
        
        taxTextField.keyboardType = UIKeyboardType.decimalPad
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    //only allow 2 numbers after decimal
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.contains("."))!
        {
            if string == "."
            {
                return false
            }
            else if textField.text?.components(separatedBy: ".")[1].count == 2 && range.length != 1{
                return false
            }
        }
        return true
    }
    
    @IBAction func pSlider(_ sender: UISlider) {
        percentLabel.text = String(Int(sender.value)) + "%"
    }
    //sending data to next two possible VC, table or split evenly
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SplitEvenlyViewController {
            let vc = segue.destination as? SplitEvenlyViewController
            let tb = Double(totalBill)!
            let tip = Double(String((percentLabel.text?.dropLast())!))!
            let tax = Double(taxTextField.text!)!
            vc?.amount = (tb*(tip/100.00) + tb + tax)/Double(numPpl)
            vc?.totalBill = (tb*(tip/100.00) + tb + tax)
            vc?.numPpl = numPpl
        } else if segue.destination is PeopleTableViewController {
            let vc = segue.destination as? PeopleTableViewController
            let tb = Double(totalBill)!
            let tip = Double(String((percentLabel.text?.dropLast())!))!
            let tax = Double(taxTextField.text!)!
            vc?.numPeople = numPpl
            vc?.totalBill = Double(totalBill)!
            vc?.taxAmount = Double(taxTextField.text!)!
            vc?.tipAmount = Double(String((percentLabel.text?.dropLast())!))! / 100
        }
    
    }
    //error checking, need to enter tax
    @IBAction func toTable(_ sender: UIButton) {
        if taxTextField.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter tax amount", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            if segment.selectedSegmentIndex == 0 {
                performSegue(withIdentifier: "toSplitEvenly",
                             sender: self)
            } else if segment.selectedSegmentIndex == 1 {
                performSegue(withIdentifier: "toPeople",
                             sender: self)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
