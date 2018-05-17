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
        
        viewModelTwo.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        
        spot.reservations = times
        tableView?.reloadData()
        //performSegue(withIdentifier: "NextCreatePage", sender: self.spot)
    }
    
}
