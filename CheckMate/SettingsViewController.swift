//
//  SettingsViewController.swift
//  CheckMate
//
//  Created by Bo Peng and Kelly Luo on 4/20/18.
//  Copyright © 2018 KB. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutLabel.text = "Logout\nTop left Button"
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
        //logout
        let image = UIImage(named: "logout")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
