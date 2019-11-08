//
//  ViewController.swift
//  On the Map
//
//  Created by fadel sultan on 10/8/19.
//  Copyright © 2019 fadel sultan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //    outlets
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //    Actions
    @IBAction func btnLogin(_ sender: Any) {
        guard let email = textFieldUsername.text , !email.isEmpty
            , let password = textFieldPassword.text , !password.isEmpty else {
                let alert = UIAlertController.alert(message: "Write email and passwod") {}
                present(alert, animated: true, completion: nil)
                return
        }
        
        model.signIn(email: email, password: password) { (isSuccess) in
            print("isSuccess " , isSuccess)
            DispatchQueue.main.async {
                if isSuccess {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TBController") as! UITabBarController
                    vc.modalPresentationStyle = .fullScreen
                    self.show(vc, sender: nil)
                }else {
                    let alert = UIAlertController.alert(message: "Wrong email or password!") {}
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
}

