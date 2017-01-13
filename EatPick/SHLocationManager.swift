//
//  SHLocationManager.swift
//  EatPick
//
//  Created by Shihao Xia on 1/11/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    static func instance()->SHLocationManager{
        return self.sharedInstance
    }
    
    static func configuration(){
        let _ = SHLocationManager.instance()
        
    }
    
    static func showOpenGPSMessage(){
        let alert = UIAlertController(title: "Hi", message: "I would like to know you current location", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler:nil)
        }))
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    func getCurrentLocation(Timeout timeout:Double, callback:@escaping (CLLocationCoordinate2D?)->Void){
        self._locationManager.startUpdatingLocation()
        var timeout = timeout
        let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            if timeout <= 0{
                callback(nil)
                self._locationManager.stopUpdatingLocation()
                timer.invalidate()
            }
            if self.currentLocation != nil {
                callback(self.currentLocation!)
                self._locationManager.stopUpdatingLocation()
                timer.invalidate()
            }
            timeout -= 0.2
        }
        timer.fire()
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
        SHLocationManager.showOpenGPSMessage()
    }


}
