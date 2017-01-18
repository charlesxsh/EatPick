//
//  SettingsViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/11/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

enum Setting:Int {
    
    //sec1
    case preference = 0
    
    //sec2
    case about = 1
    case help = 2
    case rate = 3
    
    static func getSetting(ByIndexPath indexPath:IndexPath)->Setting?{
        if  indexPath.section == 0{
            return Setting(rawValue: indexPath.row)
        }else if indexPath.section == 1{
            return Setting(rawValue: indexPath.row+1) //1 is sum of number of rows in previous section
        }
        
        return nil
        
    }
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
        Util.UIApplicationOpen(url:URL(string: "itms-apps://itunes.apple.com/app/id1193464496")!, options: [:], completionHandler: { (isSuccess) in
            if !isSuccess {
                log.error("Can not open itunes")
            }

        })

    }
    
    
}

extension SettingsTableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingType = Setting.getSetting(ByIndexPath: indexPath) else {
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
