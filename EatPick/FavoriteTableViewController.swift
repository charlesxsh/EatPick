//
//  FavoriteTableViewController.swift
//  EatPick
//
//  Created by Shihao Xia on 1/9/17.
//  Copyright © 2017 Shihao Xia. All rights reserved.
//

import UIKit
import CoreData

class FCell:UITableViewCell{
    @IBOutlet weak var photo:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var address:UILabel!
    public var favorite:Favorite?{
        didSet{
            if favorite!.photo != nil {
                self.photo.image = UIImage(data: favorite!.photo! as Data)
            }else{
                self.photo.sd_setImage(with: URL(string: favorite!.photoUrl!))
            }
            self.name.text = favorite!.name!
            self.address.text = favorite!.address!

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photo.layer.cornerRadius = 5
        self.photo.clipsToBounds = true
    }
    
}

class FavoriteTableViewController: UITableViewController {

    var favorites:[Favorite] = []
    private var emptyBackground:UIView?
    private var originalBackground:UIView?
    var selectedFavorite:Favorite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 55
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        emptyBackground = self.emptyMessage(message: "You havn't add any favorite restaurant")
        originalBackground = self.tableView.backgroundView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
        
    }
    
    func reloadTable(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            log.error("Cannot get app delegate")
            return
        }
        let managedContext =
            appDelegate.managedObjectContext
        let fetchRequest =
            NSFetchRequest<Favorite>(entityName: "Favorite")
        do {
            favorites = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        } catch let error as NSError {
            log.error("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show-detail"{
            let dest = segue.destination as! BusinessDetailTableViewController
            dest.targetFavorite = selectedFavorite
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.favorites.isEmpty{
            tableView.backgroundView = self.emptyBackground!
        }else{
            tableView.backgroundView = self.originalBackground
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFavorite = self.favorites[indexPath.row]
        self.performSegue(withIdentifier: "show-detail", sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FCell
        let business = favorites[indexPath.row]
        cell.favorite = business
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let f = self.favorites.remove(at: indexPath.row)
            f.delete()
            tableView.reloadData()
        default:
            break
        }
    }
}
