//
//  SettingsPreferenceTableViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/18/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit


class SettingsPreferenceTableViewController: UITableViewController {
    
    let datas = [SearchPreference.randomFromFavorite, SearchPreference.randomFromNearby]
    var selectedItem:SearchPreference?
    var selectedIndexPath:IndexPath?
    
    var us:UserSetting?
    override func viewDidLoad() {
        super.viewDidLoad()
        us = UserSetting.instance()
        guard
            let rawNumber = us?.get(ByKey: UserSettingKey.searchPreference.key) as? UInt8,
            let selectedItem = SearchPreference(rawValue: rawNumber)
            else {
            log.error("cannot get search preference")
            return
        }
        self.selectedItem = selectedItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Preference"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let option = self.datas[indexPath.row]
        if self.selectedItem == option {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        cell.textLabel?.text = option.userDescription
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelected = self.datas[indexPath.row]
        if newSelected != self.selectedItem{
            us?.set(value: newSelected.rawValue, ForKey: UserSettingKey.searchPreference)
            self.selectedItem = newSelected
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .none
            self.selectedIndexPath = indexPath
        }
    }
    

  
}
