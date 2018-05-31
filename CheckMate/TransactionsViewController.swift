//
//  TransactionsViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/28/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import MessageUI

class TransactionsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var data = ""
    var name = NSArray()
    var amount = NSArray()
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    @IBOutlet weak var p6: UILabel!
    @IBOutlet weak var p7: UILabel!
    @IBOutlet weak var p8: UILabel!
    @IBOutlet weak var p9: UILabel!
    @IBOutlet weak var p10: UILabel!
    @IBOutlet weak var a1: UILabel!
    @IBOutlet weak var a2: UILabel!
    @IBOutlet weak var a3: UILabel!
    @IBOutlet weak var a4: UILabel!
    @IBOutlet weak var a5: UILabel!
    @IBOutlet weak var a6: UILabel!
    @IBOutlet weak var a7: UILabel!
    @IBOutlet weak var a8: UILabel!
    @IBOutlet weak var a9: UILabel!
    @IBOutlet weak var a10: UILabel!
    
    //loading only the number of people that were eating
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Send", style: .plain, target: self, action: #selector(sendEmail))
        if 0 < name.count {
            p1.text = name[0] as? String
            a1.text = amount[0] as? String
        } else {
            p1.isHidden = true
            a1.isHidden = true
        }
        
        if 1 < name.count {
            p2.text = name[1] as? String
            a2.text = amount[1] as? String
        } else {
            p2.isHidden = true
            a2.isHidden = true
        }
        
        if 2 < name.count {
            p3.text = name[2] as? String
            a3.text = amount[2] as? String
        } else {
            p3.isHidden = true
            a3.isHidden = true
        }
        
        if 3 < name.count {
            p4.text = name[3] as? String
            a4.text = amount[3] as? String
        } else {
            p4.isHidden = true
            a4.isHidden = true
        }
        
        if 4 < name.count {
            p5.text = name[4] as? String
            a5.text = amount[4] as? String
        } else {
            p5.isHidden = true
            a5.isHidden = true
        }
        
        if 5 < name.count {
            p6.text = name[5] as? String
            a6.text = amount[5] as? String
        } else {
            p6.isHidden = true
            a6.isHidden = true
        }
        
        if 6 < name.count {
            p7.text = name[6] as? String
            a7.text = amount[6] as? String
        } else {
            p7.isHidden = true
            a7.isHidden = true
        }
        
        if 7 < name.count {
            p8.text = name[7] as? String
            a8.text = amount[7] as? String
        } else {
            p8.isHidden = true
            a8.isHidden = true
        }
        
        if 8 < name.count {
            p9.text = name[8] as? String
            a9.text = amount[8] as? String
        } else {
            p9.isHidden = true
            a9.isHidden = true
        }
        
        if 9 < name.count {
            p10.text = name[9] as? String
            a10.text = amount[9] as? String
        } else {
            p10.isHidden = true
            a10.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //EMAIL CONFIGURATIONS BELOW
    //----------------------------------
    //sending emails to anyone who wants the transaction
    @objc func sendEmail() {
        let mail = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mail, animated: true, completion: nil)
        } else { showMailError() }
    }
    
    func showMailError() {
        let mailAlert = UIAlertController(title: "Could not send mail", message: "Your device cannot send mail.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        mailAlert.addAction(dismiss)
        self.present(mailAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject("Transaction")
        if 0 < name.count {
            data = p1.text! + ": " + a1.text! + "\n"
        }
        if 1 < name.count {
            data += p2.text! + ": " + a1.text! + "\n"
        }
        if 2 < name.count {
            data += p3.text! + ": " + a1.text! + "\n"
        }
        if 3 < name.count {
            data += p4.text! + ": " + a1.text! + "\n"
        }
        if 4 < name.count {
            data += p5.text! + ": " + a1.text! + "\n"
        }
        if 5 < name.count {
            data += p6.text! + ": " + a1.text! + "\n"
        }
        if 6 < name.count {
            data += p7.text! + ": " + a1.text! + "\n"
        }
        if 7 < name.count {
            data += p8.text! + ": " + a1.text! + "\n"
        }
        if 8 < name.count {
            data += p9.text! + ": " + a1.text! + "\n"
        }
        if 9 < name.count {
            data += p10.text! + ": " + a1.text! + "\n"
        }
        mailComposerVC.setMessageBody(data, isHTML: false)
        return mailComposerVC
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
