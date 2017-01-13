//
//  ArrayExtension.swift
//  EatPick
//
//  Created by Shihao Xia on 1/9/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

extension Array{
    var randomElement: Element? {
        if count == 0{
            return nil
        }
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}
