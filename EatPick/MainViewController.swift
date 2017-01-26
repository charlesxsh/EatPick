//
//  FirstViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import FCAlertView
import NVActivityIndicatorView
import CoreLocation
import Alamofire


class MainViewController: UIViewController,UISearchControllerDelegate{
    @IBOutlet weak var pizza: UIImageView!
    var searchController:UISearchController?
    var searchResultTVC:SearchResultTableViewController?
    var originalTitleView:UIView?
    var pickedFavorite:Favorite?
    
    @IBOutlet weak var processIndicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTitleView = self.navigationItem.titleView
        let story = UIStoryboard(name: "Main", bundle: nil)
        self.searchResultTVC = story.instantiateViewController(withIdentifier: "search-result-tvc") as? SearchResultTableViewController
        
        // Do any additional setup after loading the view, typically from a nib.
        self.searchController = UISearchController(searchResultsController: self.searchResultTVC)
        self.searchController?.delegate = self
        self.searchController?.searchBar.delegate = self.searchResultTVC!
        self.searchController?.searchResultsUpdater = self.searchResultTVC
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.searchBar.tintColor = UIColor.white
        self.searchController?.searchBar.setCursorColor(color: UIColor.gray)
        self.definesPresentationContext = true
        
        //add click to pizze
        let pizzaTagGesture = UITapGestureRecognizer(target: self, action: #selector(onClickPizza(_:)))
        self.pizza.addGestureRecognizer(pizzaTagGesture)        
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Getting location"
        
        
        Alamofire.request("https://the-one-server.herokuapp.com/user", method: .post, parameters:
            ["email": "xshxsh@gmail.com"], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    log.debug(value)
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
                
            })
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        if !self.searchController!.isActive{
            processIndicator.startAnimating()
            let locationManager = SHLocationManager.instance()
            if locationManager.currentLocation == nil {
                locationManager.getCurrentLocation(Timeout: 3, callback: { (location) in
                    if location != nil{
                        self.showSearchResultController()
                    }
                })
            }else{
                self.showSearchResultController()
            }
            processIndicator.stopAnimating()
        }
    }
    
    func showSearchResultController(){
        self.navigationItem.titleView = self.searchController?.searchBar
        self.searchController?.searchBar.becomeFirstResponder()
        present(self.searchController!, animated: true, completion: nil)
    }
    
    func startPickingAnimation(){
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2*M_PI
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = 2
        self.pizza.layer.add(rotationAnimation, forKey: "rotate")
    }
    
    func stopPickingAnimatino(){
        self.pizza.layer.removeAnimation(forKey: "rotate")
    }
    
    
    func onClickPizza(_ sender:Any){
        RandomPickBusinessController(delegate: self).process()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.titleView = originalTitleView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! BusinessDetailTableViewController
        dest.targetFavorite = self.pickedFavorite
        self.pickedFavorite = nil
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.pickedFavorite != nil {
            return true
        }
        return false
    }
    
}

extension MainViewController:RandomPickBusinessControllerDelegate{
    func startRandomPick() {
        startPickingAnimation()
    }
    func pickedRandom(favorite: Favorite?) {
        stopPickingAnimatino()
        self.pickedFavorite = favorite
        self.performSegue(withIdentifier: "show-result", sender: self)
    }
}

