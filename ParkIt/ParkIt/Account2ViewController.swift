//
//  Account2ViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/18/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit

class Account2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var usernameLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents.count
    }
    
    //TODO: Aidan Make this Array (tableContents) full of the Users Parkingspots
    var tableContents = [ParkingSpot]()
    @IBOutlet weak var spotTableView: UITableView!
    
    //populates the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotTableViewCell") as! SpotTableViewCell
        // Set the first row text label to the firstRowLabel data in our current array item
        cell.spot = self.tableContents[indexPath.row]
        cell.spotLabel.text = self.tableContents[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spot = tableContents[indexPath.row]
        performSegue(withIdentifier: "goToViewSpot", sender: spot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController
        {
            let vc = segue.destination as? ViewSpotViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotTableView?.dataSource = self
        spotTableView?.delegate = self
        usernameLabel.text = UserDefaults.standard.value(forKey: "userEmail") as! String
        print(tableContents)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
