//
//  CreateSpotTwoViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

//The second view controller in the create spot sequence: allows the user to select avaliable times using a tableview.
class CreateSpotTwoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton?
    //Creating a viewModel Object
    var viewModel = ViewModel()
    var times = [String]()
    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates and style the tableview.
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .none
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //To send the ParkingSpot to the next page of creation (createSpot3)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreateSpotThreeViewController
        {
            let vc = segue.destination as? CreateSpotThreeViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func next(_ sender: Any) {
        var times = viewModel.selectedItems.map { $0.title }
        //Changing to 24 hour time for the server before pushing to spot
        var i = 0
        while i < times.count {
            if times[i].range(of: "12:") != nil {
                if times[i] == "12:00 am" {
                    times[i] = "0:00"
                } else if times[i] == "12:30 am" {
                    times[i] = "0:30"
                } else if times[i] == "12:00 pm" {
                    times[i] = "12:00"
                } else if times[i] == "12:30 pm" {
                    times[i] = "12:30"
                }
            }
            
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
        
        spot.timesAvailable = times
        tableView?.reloadData()
        performSegue(withIdentifier: "NextCreatePage", sender: self.spot)
    }
    

}
