//
//  AuthorizeController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class AuthorizeController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MainUser.loadToken() != nil {
            self.performSegueWithIdentifier("AuthAccepted", sender: self)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var authUser: UIButton!
    @IBAction func authorizeUser(sender: AnyObject) {
        if self.loginField.text == nil || self.passwordField.text == nil {
            showAlert("Логин или пароль пустые!")
            return
        }
        
        AuthorizeUser.authrorize(self.loginField.text!, pass: self.passwordField.text!) { (isAuth) in
            if isAuth == true {
                // Next segue
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("AuthAccepted", sender: self)
                })
            } else {
                self.showAlert("Неправильный логин или пароль")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func showAlert(text: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "ОК", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
