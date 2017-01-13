//
//  YelpAPI.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

enum OAuthResponse:String{
    case access_token
    case token_type
    case expires_in
}

enum OAuthHeader:String{
    case Authorization
}

class YelpAPI{
    private var yelpAppID:String?
    private var yelpAppSecret:String?
    private let baseUrl = "https://api.yelp.com/v3"
    private static let sharedInstance = YelpAPI()
    private var expiresIn:Double?
    
    private var accessToken:String?{
        didSet{
            self.authorizationHeader[OAuthHeader.Authorization.rawValue] = "Bearer \(self.accessToken!)"
        }
    }
    private var authorizationHeader:[String:String] = [:]
    
    init() {}
    
    public func businessSearch(With term:String, Location currentLocation:CLLocationCoordinate2D, handler:@escaping (DataResponse<Any>) -> Void)->DataRequest{
        let url = "\(self.baseUrl)/businesses/search"
        var parameters:[String:Any] = [:]
        parameters["latitude"] = currentLocation.latitude
        parameters["longitude"] = currentLocation.longitude
        parameters["term"] = term
        let request = Alamofire.request(url, parameters: parameters,headers: authorizationHeader)
        request.responseJSON(completionHandler: handler)
        return request
    }
    
    public func businessGet(BusinessID id:String, handler:@escaping (DataResponse<Any>) -> Void){
        let url = "\(self.baseUrl)/businesses/\(id)"
        Alamofire.request(url,headers: authorizationHeader).responseJSON(completionHandler: handler)
        
    }
    public static func configure(WithID id:String, Secret secret:String){
        let app = instance()
        app.yelpAppID = id
        app.yelpAppSecret = secret
        app.getAccessToken()
    }
    
    private func getAccessToken(){
        let parameters = [
            "grant_type":"client_credentials",
            "client_id":self.yelpAppID!,
            "client_secret":self.yelpAppSecret!
        ]
        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = value as! [String:AnyObject]
                self.accessToken = json[OAuthResponse.access_token.rawValue] as? String
                self.expiresIn = json[OAuthResponse.expires_in.rawValue] as? Double
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
    
    var isOutDate:Bool{
        return expiresIn == nil || expiresIn! < Date().timeIntervalSinceNow
    }
    
    public static func instance()->YelpAPI{
        return self.sharedInstance
    }
}


