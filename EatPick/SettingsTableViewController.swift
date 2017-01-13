//
//  SettingsViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/11/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

enum Setting:Int{
    case about = 0
    case help = 1
    case rate = 2
}
class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onClickRateMe(){
        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1193464496")!, options: [:]) { (isSuccess) in
            if !isSuccess {
                log.error("Can not open itunes")
            }
        }

    }
}

extension SettingsTableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingType = Setting(rawValue: indexPath.row) else {
            return
        }
        switch settingType {
        case .rate:
            onClickRateMe()
        default:
            break
        }
    }
}
