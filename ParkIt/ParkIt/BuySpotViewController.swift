//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase

class BuySpotViewController: UIViewController {
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton?
    var times = [String]()
    var spot:ParkingSpot = ParkingSpot()
    var viewModelTwo = ViewModelTwo()
    
    override func viewDidLoad() {
        viewModelTwo = ViewModelTwo(spot: spot)
        spotLabel.text = "Spot: " + spot.title!
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 80
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModelTwo// as! UITableViewDataSource
        tableView?.delegate = viewModelTwo// as! UITableViewDelegate
        tableView?.separatorStyle = .none
        
        ref = Database.database().reference()
        
        viewModelTwo.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //To send the ParkingSpot to the next page of creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BuySpotSummaryViewController
        {
            let vc = segue.destination as? BuySpotSummaryViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func next(_ sender: Any) {
        var times = viewModelTwo.selectedItems.map { $0.title }
        //Changing to 24 hour time for the server before pushing to spot
        var i = 0
        while i < times.count {
            if times[i].range(of: " pm") != nil {
                times[i] = times[i].replacingOccurrences(of: " pm", with: "", options: .regularExpression)
                var hours = 0
                if times[i].range(of: ":00") != nil {
                    hours = Int(times[i].replacingOccurrences(of: ":00", with: ""))!
                    times[i] = String(Int(hours) + 12) + ":00"
                }
                else {
                    hours = Int(times[i].replacingOccurrences(of: ":30", with: ""))!
                    times[i] = String(Int(hours) + 12) + ":30"
                }
            }
            
            times[i] = times[i].replacingOccurrences(of: " am", with: "", options: .regularExpression)
            i = i + 1
        }
        
        var numSpots = 0
        var spotName = ""
        var changingSpotTitle = ""
        var numReservations = 0
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            numSpots = spots.count
            var currentSpotNum = numSpots - 1
            
            //Start cycling through all the spots and find which one
            let jj = 0
            while jj <= currentSpotNum
            {
                spotName = "Spot-0x" + String(format: "%04d", currentSpotNum)
                let dict: NSDictionary = spots.value(forKey: spotName) as! NSDictionary
                let id = dict.value(forKey: "id") as! String
                if (id == self.spot.uniqueId) {
                    changingSpotTitle = spotName
                    numReservations = (dict.value(forKey: "Reservations") as! NSDictionary).count
                }
                currentSpotNum = currentSpotNum - 1
            }
            
            if (changingSpotTitle == "") {
                let alert = UIAlertController(title: "ID Failure", message: "The id for the spot could not be found.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Whoops", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            //TODO: SETTING THIS TO 0 WILL OVERWRITE THE VALUES IN RESERVATIONS
            var resCounter = 0
            while resCounter < times.count
            {
                let resNumber = String(format: "%02d", numReservations+resCounter)
                self.ref.child("Spots/\(changingSpotTitle)/Reservations/Res-" + resNumber).setValue(times[resCounter])
                resCounter = resCounter + 1
            }
            
            self.spot.reservations = times
            self.tableView?.reloadData()
            self.performSegue(withIdentifier: "SummarySegue", sender: self.spot)
        })
    }
}
