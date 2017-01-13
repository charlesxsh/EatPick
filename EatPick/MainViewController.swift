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

class MainViewController: UIViewController,UISearchBarDelegate,UISearchControllerDelegate{
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
        self.searchController?.searchBar.delegate = self
        self.searchController?.searchResultsUpdater = self.searchResultTVC
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.searchBar.tintColor = UIColor.white
        self.definesPresentationContext = true
        
        //add click to pizze
        let pizzaTagGesture = UITapGestureRecognizer(target: self, action: #selector(onClickPizza(_:)))
        self.pizza.addGestureRecognizer(pizzaTagGesture)        
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Getting location"
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        if !self.searchController!.isActive{
            processIndicator.startAnimating()
            let locationManager = SHLocationManager.instance()
            if locationManager.currentLocation == nil{
                locationManager.getCurrentLocation(Timeout: 3, callback: { (location) in
                    if location != nil{
                        self.showSearchResultController()
                    }else {
                        let alert = FCAlertView()
                        alert.autoHideSeconds = 3
                        alert.cornerRadius = 0
                        alert.colorScheme = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
                        alert.showAlert(inView: self,
                                        withTitle: "Oh",
                                        withSubtitle: "Can not get your current location",
                                        withCustomImage: nil,
                                        withDoneButtonTitle: "I got it!",
                                        andButtons: nil)
                    }
                    self.processIndicator.stopAnimating()
                })
            }else{
                processIndicator.stopAnimating()
                self.showSearchResultController()
            }
        }
    }
    
    func showSearchResultController(){
        self.navigationItem.titleView = self.searchController?.searchBar
        self.searchController?.searchBar.becomeFirstResponder()
        present(self.searchController!, animated: true, completion: nil)
    }
    
    
    func onClickPizza(_ sender:Any){
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2*M_PI
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = 2
        self.pizza.layer.add(rotationAnimation, forKey: "rotate")
        
        
        self.pickedFavorite = Favorite.randomPickOne()
        if self.pickedFavorite == nil {
            self.pizza.layer.removeAnimation(forKey: "rotate")
            let alert = FCAlertView()
            alert.autoHideSeconds = 3
            alert.cornerRadius = 0
            alert.colorScheme = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            alert.showAlert(inView: self,
                            withTitle: "Oh",
                            withSubtitle: "You don't have any favorite restaurant currently",
                            withCustomImage: nil,
                            withDoneButtonTitle: "I got it!",
                            andButtons: nil)
            return
        }
        self.pizza.layer.removeAnimation(forKey: "rotate")
        log.debug("stop pizza")
        self.performSegue(withIdentifier: "show-result", sender: self)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.titleView = originalTitleView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! RandomResultTableViewController
        dest.targetFavorite = self.pickedFavorite
    }
    
    
}

