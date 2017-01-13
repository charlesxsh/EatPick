//
//  CustomButton.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 2 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? = UIColor.white {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
extension UIButton{
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
