//
//  PListManager.swift
//  EatPick
//
//  Created by Shihao Xia on 1/18/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit

class PListManager{
    var plistFilePath:String?
    var plistFiledata:NSMutableDictionary
    var isChanged:Bool = false
    
    public init(fileName:String){
        let documentPathArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPathArray[0]
        self.plistFilePath = documentPath + "/\(fileName).plist"
        let fm = FileManager()
        if !fm.fileExists(atPath: self.plistFilePath!){
            let bundlePlistFilePath = Bundle.main.path(forResource: fileName, ofType: "plist")
            do{
                try fm.copyItem(atPath: bundlePlistFilePath!, toPath: self.plistFilePath!)
            }catch let error {
                log.error(error.localizedDescription)
            }
        }
        self.plistFiledata = NSMutableDictionary(contentsOfFile: self.plistFilePath!)!
    }
    
    public func save(){
        if isChanged {
            self.plistFiledata.write(toFile: self.plistFilePath!, atomically: true)
        }
    }
    
    internal func set(key:String, value:Any){
        self.plistFiledata[key] = value
        self.isChanged = true
    }
}
