//
//  CustomButton.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit


extension UIButton{
    func unClicked(){
        self.setImage(UIImage(named: "plus-icon"), for: .normal)
        self.isUserInteractionEnabled = true

    }
    func clicked(){
        self.setImage(UIImage(named: "click-icon"), for: .normal)
        self.isUserInteractionEnabled = false
    }
    
    var cornerRadius:CGFloat{
        set(radius){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        }
        get{
            return self.layer.cornerRadius
        }
    }
    
    func runIndicatorWith(task:()->Void){
        let indicator = UIActivityIndicatorView()
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        
        indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        DispatchQueue.main.async {
            self.imageView?.removeFromSuperview()
            self.addSubview(indicator)
        }
        task()
        indicator.stopAnimating()
        DispatchQueue.main.async {
            indicator.removeFromSuperview()
            self.addSubview(self.imageView!)
        }
    }
}
