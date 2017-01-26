//
//  MessageCenter.swift
//  EatPick
//
//  Created by Shihao Xia on 1/19/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import FCAlertView

class MessageCenter{
    private static let sharedInstance = MessageCenter()
    
    private var alert:FCAlertView?
    private init(){
        alert = FCAlertView()
        alert?.autoHideSeconds = 3
        alert?.colorScheme = UIColor(red: 219/255, green: 158/255, blue: 54/255, alpha: 1)
    }
    
    public static func instance()->MessageCenter{
        return sharedInstance
    }
    
    public func show(In viewController:UIViewController? = nil, title:String?, message:String){
        var vc:UIViewController?
        if viewController == nil {
            vc = UIApplication.shared.delegate?.window!?.rootViewController
        }else {vc = viewController}
        alert?.showAlert(inView: vc,
                        withTitle: title ?? "",
                        withSubtitle: message,
                        withCustomImage: nil,
                        withDoneButtonTitle: "I got it!",
                        andButtons: nil)
    }
    
    public func show(In viewController:UIViewController? = nil, title:String?, message:String, buttons:[String], closures:[FCActionBlock]){
        var vc:UIViewController?
        if viewController == nil {
            vc = UIApplication.shared.delegate?.window!?.rootViewController
        }else {vc = viewController}
        let customAlert = FCAlertView()
        for i in 0..<buttons.capacity{
            customAlert.addButton(buttons[i], withActionBlock: closures[i])
        }
        customAlert.showAlert(inView: vc,
                         withTitle: title ?? "",
                         withSubtitle: message,
                         withCustomImage: nil,
                         withDoneButtonTitle: "I got it!",
                         andButtons: nil)

        
    }
}
