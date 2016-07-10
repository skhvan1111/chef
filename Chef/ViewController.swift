//
//  ViewController.swift
//  Chef
//
//  Created by Кирилл Салтыков on 09.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let product = Product(id: "5781186188daeed863ec163f", name: "asd", imageUrl: "asd.jpg")
        FridgeRequester.deleteProductFromFridge(product.getId()) { (isDeleted) in
            print("PRODUCT DELETE: \(isDeleted)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

