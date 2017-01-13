//
//  SecondViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/8/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import CoreLocation
import FCAlertView
import NVActivityIndicatorView

class SRCell:UITableViewCell{
    @IBOutlet weak var photo:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var address:UILabel!
    @IBOutlet weak var add:UIButton!
    public var businessObject:[String:Any]?{
        didSet{
            self.name.text = businessObject!.getString(By: "name")
            //handle business address
            let locationObject = businessObject!["location"] as! [String:AnyObject]
            let address = locationObject.getString(By: "address1")
            let city = locationObject.getString(By: "city")
            let state = locationObject.getString(By: "state")
            self.address.text = "\(address), \(city), \(state)"
            //handle business image
            let imageUrl = businessObject!["image_url"] as! String
            self.photo.sd_setImage(with: URL(string:imageUrl))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photo.layer.cornerRadius = 5
        self.photo.clipsToBounds = true
    }
    
    
    @IBAction func onAddClick(_ sender:AnyObject?){
        self.add.runIndicatorWith { 
            guard let newFavorite = Favorite.newObject() else{
                log.error("Create favorite failed")
                return
            }
            newFavorite.address = self.address.text!
            newFavorite.name = self.name.text!
            newFavorite.businessId = self.businessObject?.getString(By: "id")
            
            if self.photo.image != nil {
                newFavorite.photo = UIImageJPEGRepresentation(self.photo.image!, 1) as NSData?
            }
            newFavorite.photoUrl =  businessObject!.getString(By: "image_url")
            let coordinates = businessObject!["coordinates"] as! [String:AnyObject]
            newFavorite.latitude = coordinates["latitude"] as! Float
            newFavorite.longitude = coordinates["longitude"] as! Float
            
            newFavorite.phone = businessObject!.getString(By: "phone")
            self.add.setImage(UIImage(named: "click-icon"), for: .normal)
            self.add.isUserInteractionEnabled = false
        }
        
        
        
        
 }
}

class SearchResultTableViewController: UITableViewController,UISearchResultsUpdating,NVActivityIndicatorViewable {
    
    var yelpApi:YelpAPI?
    var searchText:String?
    var searchResults:[[String:Any]]?
    var previousRequest:DataRequest?
    var currentLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        yelpApi = YelpAPI.instance()
        let locationManager = SHLocationManager.instance()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        currentLocation = locationManager.currentLocation!
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTable(sender:Any){
        if !self.refreshControl!.isRefreshing{
            self.refreshControl!.beginRefreshing()
        }
        guard self.searchText!.characters.count > 0 else{
            self.refreshControl!.endRefreshing()
            return
        }
        if previousRequest != nil {
            previousRequest!.cancel()
        }
        previousRequest = yelpApi?.businessSearch(With: self.searchText!, Location: self.currentLocation!, handler: { (response) in
            switch response.result{
            case .success(let value):
                let json = value as! [String:Any]
                self.searchResults = json["businesses"] as? [[String:Any]]
                self.tableView.reloadData()
            case .failure(let error):
                log.error(error.localizedDescription)
            }
            self.refreshControl!.endRefreshing()
        })
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.searchText = searchController.searchBar.text
        guard self.searchText != nil else {
            return
        }
        self.refreshControl?.sendActions(for: .valueChanged)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SRCell
        //handle business name
        cell.businessObject = self.searchResults![indexPath.row]
        return cell
    }
    
    


}



