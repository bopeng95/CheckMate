//
//  SignUpViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/12/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tap outside to leave keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        doneBtn.layer.cornerRadius = 5;
        backBtn.layer.cornerRadius = 5;
        signUpLabel.clipsToBounds = true;
        signUpLabel.layer.cornerRadius = 5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //creates the user function here with error checking
    @IBAction func createUser(_ sender: Any) {
        if name.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter your name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else if email.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else if (password1.text != password2.text) {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password1.text!) { (user, error) in
                
                if error == nil {
                    //Goes to the page which lets user pick how many people are in their group
                    let ref = Database.database().reference(fromURL: "Firebase Database URL here")
                    let usersRef = ref.child("users").child((user?.uid)!)
                    //let trans = Transactions(name:[], amount:[])
                    let values = ["name": self.name.text!, "email": self.email.text!, "password": self.password1.text!, "transactions":[]] as [String : Any]
                    usersRef.updateChildValues(values)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)

                    let alert1 = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(alert1)

                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func goBackToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
