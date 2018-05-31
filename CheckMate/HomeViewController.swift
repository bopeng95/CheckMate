//
//  HomeViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/18/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pplLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numSlider: UISlider!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var totalBillTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalBillTextField.delegate = self
        //tap outside to leave keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        pplLabel.clipsToBounds = true
        totalBill.clipsToBounds = true
        pplLabel.layer.cornerRadius = 5;
        totalBill.layer.cornerRadius = 5;
        nextBtn.layer.cornerRadius = 5;
        
        totalBillTextField.keyboardType = UIKeyboardType.decimalPad
        
        //making the button round on the right side
        let path = UIBezierPath(roundedRect: nextBtn.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        nextBtn.layer.mask = mask
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
        getUsername()
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
    
    //error checking before going to the next VC
    @IBAction func nextVC(_ sender: Any) {
        if totalBillTextField.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter total bill amount", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toNextOne",
                     sender: self)
        }
    }
    //sending data over to next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is NextOneViewController {
            let vc = segue.destination as? NextOneViewController
            vc?.totalBill = totalBillTextField.text!
            vc?.numPpl = Int(numLabel.text!)!
        }
    }
    
    @IBAction func slider(_ sender: UISlider) {
        numLabel.text = String(Int(sender.value))
    }
    //displaying the name of the user
    func getUsername() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(DataEventType.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            })
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
    @IBAction func logoutBtn(_ sender: Any) {
        handleLogout()
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
