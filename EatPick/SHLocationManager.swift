//
//  SHLocationManager.swift
//  EatPick
//
//  Created by Shihao Xia on 1/11/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import CoreLocation

typealias GetLocation = (CLLocationCoordinate2D?)->Swift.Void


class SHLocationRequest{
    var timeOut:Double?
    var callback:GetLocation?
    var timer:Timer?
    private static let timeInterval = 0.1
    private var manager:SHLocationManager?
    
    init(manager:SHLocationManager) {
        self.manager = manager
    }
    
    @objc private func tryToGetLocation(){
        if timeOut! <= 0.0 {
            callback?(nil)
            self.timer?.invalidate()
        }
        if manager!.currentLocation != nil{
            callback?(manager!.currentLocation)
            self.timer?.invalidate()
        }else{
            self.timeOut! -= SHLocationRequest.timeInterval
        }
    }
    
    func start(){
        self.timer = Timer.scheduledTimer(timeInterval: SHLocationRequest.timeInterval, target: self, selector: #selector(tryToGetLocation), userInfo: nil, repeats: true)
        self.timer!.fire()
    }
    
}
class SHLocationManager:NSObject{
    private var _locationManager:CLLocationManager = CLLocationManager()
    private static let sharedInstance = SHLocationManager()
    public var currentLocation:CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        log.debug("SHLocationManager init()")
        self._locationManager.delegate = self
        self._locationManager.requestWhenInUseAuthorization()
        self._locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func getNewLocationRequest()->SHLocationRequest{
        let req = SHLocationRequest(manager: self)
        return req
    }
    
    static func instance()->SHLocationManager{
        return self.sharedInstance
    }
    
    static func configuration(){
        let _ = SHLocationManager.instance()
        
    }
    
    static func showOpenGPSMessage(){
        let alert = UIAlertController(title: "Hi", message: "I would like to know you current location", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            Util.UIApplicationOpen(url: URL(string:UIApplicationOpenSettingsURLString)!)
        }))
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    
    func getCurrentLocation(Timeout timeOut:Double, callback:@escaping GetLocation){
        self._locationManager.startUpdatingLocation()
        let newReq = self.getNewLocationRequest()
        newReq.timeOut = timeOut
        newReq.callback = callback
        newReq.start()
    }
    
    
    
}

extension SHLocationManager:CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.currentLocation = manager.location?.coordinate
        if self.currentLocation != nil {
            manager.stopUpdatingLocation()
        }
    }

    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            manager.startUpdatingLocation()
        case .denied,.restricted:
            currentLocation = nil
            SHLocationManager.showOpenGPSMessage()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        log.error(error.localizedDescription)
    }


}
