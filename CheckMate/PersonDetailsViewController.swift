//
//  PersonDetailsViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/25/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var personsName: UILabel!
    @IBOutlet weak var payAmount: UILabel!
    @IBOutlet weak var changeNameField: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var addRemoveField: UITextField!
    
    var person:People?
    var saveStatus:Int = 0
    var totalAmount:Double = 0
    
    //displaying the persons name and amount to pay
    override func viewDidLoad() {
        super.viewDidLoad()
        addRemoveField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateDetails))
        personsName.text = person?.name
        payAmount.text = String(format: "$%.02f", (person?.money)!)
        addRemoveField.keyboardType = UIKeyboardType.decimalPad
        // Do any additional setup after loading the view.
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
    //update the changes made with error checking
    @objc func updateDetails() {
        if changeNameField.text != "" {
            person?.name = changeNameField.text!
            personsName.text = person?.name
            changeNameField.text = ""
        }
        if addRemoveField.text != "" && saveStatus == 0{
            if segment.selectedSegmentIndex == 0 {
                let result = (person?.money)! + Double(addRemoveField.text!)!
                if result > totalAmount {
                    let alert = UIAlertController(title: "Error", message: "You are over paying.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    person?.money = result
                    payAmount.text = String(format: "$%.02f", (person?.money)!)
                    addRemoveField.text = ""
                }
            } else if segment.selectedSegmentIndex == 1 {
                let result = (person?.money)! - Double(addRemoveField.text!)!
                if result < 0 {
                    let alert = UIAlertController(title: "Error", message: "You are removing too much.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    person?.money = result
                    payAmount.text = String(format: "$%.02f", (person?.money)!)
                    addRemoveField.text = ""
                }
            }
        } else if saveStatus == 1 {
            if addRemoveField.text != "" {
                let alert = UIAlertController(title: "Error", message: "You already added tip and tax!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
            }
        }
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
