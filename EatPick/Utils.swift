//
//  Utils.swift
//  EatPick
//
//  Created by Shihao Xia on 1/17/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

class Util {
    static func UIApplicationOpen(url:URL, options:[String : Any] = [:], completionHandler completion: ((Bool) -> Swift.Void)? = nil){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: options, completionHandler: completion)
        } else {
            let ret = UIApplication.shared.openURL(url)
            guard completion != nil else {
                return
            }
            completion!(ret)
        }

    }
}
