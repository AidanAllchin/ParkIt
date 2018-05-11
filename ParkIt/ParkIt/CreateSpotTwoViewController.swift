//
//  CreateSpotTwoViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class CreateSpotTwoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton?
    var viewModel = ViewModel()
    
    var times = [String]()
    var spot:ParkingSpot = ParkingSpot()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    //To send the ParkingSpot to the next page of creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreateSpotThreeViewController
        {
            let vc = segue.destination as? CreateSpotThreeViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func next(_ sender: Any) {
        print(viewModel.selectedItems.map { $0.title })
        tableView?.reloadData()
    }
    

}
