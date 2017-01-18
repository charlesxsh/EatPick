//
//  HelpFeedbackTableViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/11/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

enum HelpFeedback:Int{
    case email = 0
}

class HelpFeedbackTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = HelpFeedback(rawValue: indexPath.row) else{
            return
        }
        switch cellType {
        case .email:
            Util.UIApplicationOpen(url:URL(string: "mailto://charlesxiash@gmail.com")!, options: [:], completionHandler: { (isSuccess) in
                if !isSuccess{
                    log.error("Cannot open email")
                }
            })
        }
    }
   
}
