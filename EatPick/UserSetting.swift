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

enum SearchPreference:UInt8{
    case randomFromNearby = 0
    case randomFromFavorite = 1
    
    var userDescription:String{
        switch self {
        case .randomFromFavorite:
            return "Pick From Favorite"
        case .randomFromNearby:
            return "Pick From Nearby"
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
    

    
    func set(value:Any, ForKey key:UserSettingKey){
        set(key: key.key, value: value)
    }
    
    
}
