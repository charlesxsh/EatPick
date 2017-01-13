//
//  RandomResultTableViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/9/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import MapKit

class RRCell:UITableViewCell{
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var map:MKMapView!
    @IBOutlet weak var address:UILabel!
    var favorite:Favorite?{
        didSet{
            guard let favorite = self.favorite else {
                return
            }
            self.name.text = favorite.name!
            self.address.text = "\(favorite.category ?? "")\n\(favorite.address ?? "")"
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(favorite.latitude), longitude:CLLocationDegrees(favorite.longitude))
            annotation.coordinate = centerCoordinate
            annotation.title = favorite.name!
            map.addAnnotation(annotation)
            map.showsUserLocation = true
            let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            let adjustRegion  = map.regionThatFits(region)
            map.setRegion(adjustRegion, animated: true)
        }
    }
}

class RRPhoneCell:UITableViewCell{
    @IBOutlet weak var phone:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phone.textContainer.lineFragmentPadding = 0;
        phone.textContainerInset.top = 4
    }
}

enum CellID:UInt8{
    case meta
    case phoneButton
    case locationButton
    
    var identifier:String{
        switch self {
        case .meta:
            return "meta"
        case .phoneButton:
            return "phobutton"
        case .locationButton:
            return "locbutton"
        }
    }
}

class BusinessDetailTableViewController: UITableViewController {

    var targetFavorite:Favorite?
    let cellTemplates = [CellID.meta, CellID.phoneButton, CellID.locationButton]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = self.targetFavorite!.name!

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTemplates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = cellTemplates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.identifier, for: indexPath)
        switch cellID {
        case .meta:
            let metaCell = cell as! RRCell
            metaCell.favorite = targetFavorite
        case .locationButton:
            break
        case .phoneButton:
            let phoneCell = cell as! RRPhoneCell
            phoneCell.phone.text = "Call \(targetFavorite!.phone!)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellID = cellTemplates[indexPath.row]
        
        let targetLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(targetFavorite!.latitude), longitude: CLLocationDegrees(targetFavorite!.longitude))
        switch cellID {
        case .locationButton:
            let appleMapUrl = URL(string:"http://maps.apple.com/maps/")
            let googleMapUrl = URL(string:"comgooglemaps://?saddr=&daddr=\(targetLocation.latitude),\(targetLocation.longitude)&directionsmode=driving")
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if UIApplication.shared.canOpenURL(appleMapUrl!){
                let appleAction = UIAlertAction(title: "Apple Map", style: .default, handler: { (action) in
                    let placemark = MKPlacemark(coordinate: targetLocation, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = "\(self.targetFavorite!.name!)"
                    mapItem.openInMaps(launchOptions: [:])
                })
                alert.addAction(appleAction)
            }
            if UIApplication.shared.canOpenURL(googleMapUrl!){
                let googleAction = UIAlertAction(title: "Google Map", style: .default, handler: { (action) in
                    
                })
                alert.addAction(googleAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}
