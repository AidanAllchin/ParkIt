//
//  BuySpotViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 3/11/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class BuySpotViewController: UIViewController {
    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton?
    var times = [String]()
    var spot:ParkingSpot = ParkingSpot()
    var viewModel = ViewModelTwo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModelTwo(spot: spot)
        spotLabel.text = "Spot: " + spot.title!
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModel// as! UITableViewDataSource
        tableView?.delegate = viewModel// as! UITableViewDelegate
        tableView?.separatorStyle = .none
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
        
    }

}
