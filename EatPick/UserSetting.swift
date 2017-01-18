//
//  UserSetting.swift
//  EatPick
//
//  Created by Shihao Xia on 1/18/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit


enum UserSettingKey:UInt8{
    case searchPreference
    
    var key:String{
        switch self {
        case .searchPreference:
            return "Search Preference"
        }
    }
}

class UserSetting: PListManager {
    private static let sharedInstance = UserSetting()
    
    private init(){
        super.init(fileName: "UserSetting")
    }
    
    static func instance() -> UserSetting {
        return sharedInstance
    }
    
    func get<T>(ByKey key:UserSettingKey)->T{
        return self.plistFiledata[key.key] as! T
    }
    
    func set(value:Any, ForKey key:UserSettingKey){
        set(key: key.key, value: value)
    }
    
    
}
