//
//  RecipeStepsController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class RecipeStepsController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var textDecription: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    
    
    private var recipe: Recipe!
    
    var step = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stepButton.hidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textDecription.text = "Рецепт: \(recipe.getName())\n\(recipe.getDecription())\nШагов:\(recipe.getSteps().count)"
    }
    
    @IBAction func nextStep(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mainButton.hidden = true
            self.stepButton.hidden = false
        }
        
        if self.step == self.recipe.getSteps().count {
            print("End of steps")
            let vc = storyboard?.instantiateViewControllerWithIdentifier("SuccessView")
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        
        let step = self.recipe.getSteps()[self.step]
        self.textDecription.text = step.getDescription()
        self.step += 1
    }
    
    @IBAction func stepNext(sender: AnyObject) {
        if self.step == self.recipe.getSteps().count {
            print("End of steps")
            let vc = storyboard?.instantiateViewControllerWithIdentifier("SuccessView")
            self.navigationController?.pushViewController(vc!, animated: true)
            return
        }
        
        let step = self.recipe.getSteps()[self.step]
        self.textDecription.text = step.getDescription()
        self.step += 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpRecipe(recipe: Recipe) {
        self.recipe = recipe
    }

}
