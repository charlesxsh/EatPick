//
//  DictionaryExtension.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

extension Dictionary{
    func getString(By key:String)->String{
        return self[key as! Key] as? String ?? ""
    }
}
