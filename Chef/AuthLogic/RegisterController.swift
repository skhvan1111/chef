//
//  RegisterController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
        if emailField.text == nil || loginField.text == nil || passField.text == nil {
            showAlert("Поля не могут быть пустыми")
        }
        
        AuthorizeUser.registerUser(loginField.text!, email: emailField.text!, pass: passField.text!) { (isRegistered) in
            if isRegistered == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("RegisterSuccess", sender: self)
                })
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
