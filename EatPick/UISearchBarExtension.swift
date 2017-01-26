//
//  UISearchBarExtension.swift
//  EatPick
//
//  Created by Shihao Xia on 1/19/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

extension UISearchBar{
    func setCursorColor(color:UIColor){
        for view in self.subviews.first!.subviews
        {
            if view.isKind(of: UITextField.self)
            {
                view.tintColor = color
                break
            }
        }
    }
}
