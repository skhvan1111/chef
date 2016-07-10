//
//  ViewController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 09.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    private var token: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let instance = VKSdk.initializeWithAppId("5539003")
        instance.registerDelegate(self as VKSdkDelegate)
        instance.uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginInVk(sender: AnyObject) {
        //VKSdk.authorize([VK_PER_OFFLINE])
    }
    
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        self.presentViewController(controller, animated: true, completion: nil)
    }

    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        print("Result: \(result.state.rawValue)")
        if result.state.rawValue == 2 {
            // Success auth
            self.token = VKSdk.accessToken().accessToken
            MainUser.registerInService(self.token)
        } else {
            self.showAlert("Ошибка авторизации")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.showAlert("Ошибка авторизации")
    }
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        self.showAlert("Необходимо ввести капчу!")
    }
    
    private func showAlert(text: String) {
        dispatch_async(dispatch_get_main_queue()) { 
            let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "ОК", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

