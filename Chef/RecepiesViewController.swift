//
//  RecepiesViewController.swift
//  Chef
//
//  Created by Dasha Korneichuk on 09.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class CategoryRecepiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                                                                    NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectSnack(sender: AnyObject) {
    }
    
    @IBAction func selectHealthyFood(sender: AnyObject) {
    }

    @IBAction func selectSalad(sender: AnyObject) {
    }
    
    @IBAction func selectMeet(sender: AnyObject) {
    }
    
    @IBAction func selectBreakfast(sender: AnyObject) {
    }
    
    @IBAction func selectBakery(sender: AnyObject) {
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
