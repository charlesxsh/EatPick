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
            guard let businessObject = businessObject else{
                return
            }
            self.name.text = businessObject.getString(By: "name")
            //handle business address
            let locationObject = businessObject["location"] as! [String:AnyObject]
            let address = locationObject.getString(By: "address1")
            let city = locationObject.getString(By: "city")
            let state = locationObject.getString(By: "state")
            self.address.text = "\(address), \(city), \(state)"
            //handle business image
            let imageUrl = businessObject["image_url"] as! String
            self.photo.sd_setImage(with: URL(string:imageUrl))
            
            if Favorite.isExistObject(ById: businessObject.getString(By: "id")){
                self.add.clicked()
            }else{
                self.add.unClicked()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photo.layer.cornerRadius = 5
        self.photo.clipsToBounds = true
        self.add.cornerRadius = 5
    }
    
    
    @IBAction func onAddClick(_ sender:AnyObject?){
        self.add.runIndicatorWith { 
            guard let newFavorite = Favorite.newObjectWithContext() else{
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
            
            let categories = businessObject!["categories"] as! [[String:String]]
            var cateString = ""
            for c in categories{
                cateString.append("\(c["title"]!) & ")
            }
            cateString.remove(at: cateString.index(cateString.endIndex, offsetBy: -2))
            newFavorite.category =  cateString

            self.add.clicked()
        }
        
        
        
        
 }
}

class SearchResultTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate {
    
    var yelpApi:YelpAPI?
    var searchText:String?
    var searchResults:[[String:Any]]?
    var previousRequest:DataRequest?
    var currentLocation:CLLocationCoordinate2D?
    var searchTimer:Timer?
    private var emptyBackground:UIView?
    private var originalBackground:UIView?
    

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
        emptyBackground = self.emptyMessage(message: "Found nothing")
        originalBackground = self.tableView.backgroundView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchResults = nil
        self.tableView.reloadData()
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
        previousRequest = yelpApi?.businessSearch(With: self.searchText!, Option:["limit":12] ,Location: self.currentLocation!, handler: { (response) in
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
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshTable(sender:)), object: nil)
        self.perform(#selector(refreshTable(sender:)), with: nil, afterDelay: 0.2)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.searchResults != nil) && self.searchResults!.isEmpty {
            tableView.backgroundView = self.emptyBackground!
        }else{
            tableView.backgroundView = self.originalBackground
        }
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let rows = self.searchResults else {return}
        let shouldLoadRow = rows.count - 3
        if indexPath.row == shouldLoadRow{
            let offset = rows.count
            _ = yelpApi?.businessSearch(With: self.searchText!,Option:["offset":offset,"limit":8], Location: self.currentLocation!, handler: { (response) in
                switch response.result{
                case .success(let value):
                    let json = value as! [String:Any]
                    guard let offsetResults = json["businesses"] as? [[String:Any]] else {
                        return
                    }
                    self.searchResults?.append(contentsOf: offsetResults)
                    self.tableView.reloadData()
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
                self.refreshControl!.endRefreshing()
            })

        }
    }
    
    


}



