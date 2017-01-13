//
//  UITableViewExtension.swift
//  EatPick
//
//  Created by Shihao Xia on 1/9/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

extension UITableViewController{
 func emptyMessage(message:String) -> UIView{
    let messageLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = UIColor.black
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
    messageLabel.sizeToFit()
    return messageLabel
    }
}
