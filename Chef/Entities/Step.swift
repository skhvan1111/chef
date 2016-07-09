//
//  Step.swift
//  Chef
//
//  Created by Кирилл Салтыков on 10.07.16.
//  Copyright © 2016 ChefTeam. All rights reserved.
//

import Foundation


class Step {
    private let description: String
    private let imageUrl: String
    
    init(descr: String, imgUrl: String) {
        self.description = descr
        self.imageUrl = imgUrl
    }
}


class StepMapper {
    class func parseStep(dict: NSDictionary) -> Step {
        let descr = dict.valueForKey("description") as! String
        let imageUrl = dict.valueForKey("imageUrl") as! String
        return Step(descr: descr, imgUrl: imageUrl)
    }
}