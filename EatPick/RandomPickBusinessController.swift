//
//  RandomPickBusinessController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/19/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
protocol RandomPickBusinessControllerDelegate {
    func startRandomPick()
    func pickedRandom(favorite:Favorite?)
}

class RandomPickBusinessController{
    var delegate:RandomPickBusinessControllerDelegate?
    
    public init(delegate:RandomPickBusinessControllerDelegate){
        self.delegate = delegate
    }
    
    private func handleRandomFromFavorite(){
        guard let pickedFavorite = Favorite.randomPickOne() else {
            MessageCenter.instance().show(title: "Oh", message: "You don't have any favorite restaurant currently")
            return
        }
        delegate?.pickedRandom(favorite: pickedFavorite)
    }
    
    private func handleRandomFromNearBy(){
        let locationManager = SHLocationManager.instance()
            locationManager.getCurrentLocation(Timeout: 3, callback: { (location) in
                if location != nil {
                    _ = YelpAPI.instance().businessSearch(With: nil, Option: ["radius":4000,"limit":10], Location: location!, handler: { (response) in
                        switch response.result{
                        case .success(let value):
                            let json = value as! [String:Any]
                            let searchResults = json["businesses"] as? [[String:Any]]
                            let js = searchResults?.randomElement
                            guard let businessJson = js else{
                                MessageCenter.instance().show(title: "Oh", message: "Not found appropriate restaurant")
                                self.delegate?.pickedRandom(favorite: nil)
                                break
                            }
                            let pickedFavorite = Favorite.newObject(WithYelpBusinessJson: businessJson)
                            self.delegate?.pickedRandom(favorite: pickedFavorite)
                        case .failure(let error):
                            log.error(error.localizedDescription)
                        }
                    })
                }
            })
    }
        
    public func process(){
        delegate?.startRandomPick()
        let us = UserSetting.instance()
        guard let optionNumber = us.get(ByKey: UserSettingKey.searchPreference.key) as? UInt8 else {
            MessageCenter.instance().show(title: "Oh", message: "Incorrect search setting")
            return
        }
        guard let searchOption = SearchPreference(rawValue: optionNumber) else{
            MessageCenter.instance().show(title: "Oh", message: "Incorrect search setting")
            return
        }
        switch searchOption {
        case .randomFromFavorite:
            self.handleRandomFromFavorite()
        case .randomFromNearby:
            self.handleRandomFromNearBy()

        }
    }
}
