//
//  CreateSpotFinishedViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class CreateSpotFinishedViewController: UIViewController {
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var numSpots = 0
    
    var spot:ParkingSpot = ParkingSpot()
    
    var spotTitle = "Empty"
    var location = CLLocationCoordinate2D()
    var address = "Address"

    @IBOutlet weak var spotTitleLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotTitleLabel.text = spot.title
        addressLabel.text = spot.address
        coordinateLabel.text = "\(spot.coordinate.latitude)" + ", \(spot.coordinate.longitude)"
        
        /*ref?.observe(.value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            self.numSpots = spots.count
        })*/
        
        // Do any additional setup after loading the view.
    }
    
    //Runs the code to create the spot and goes back to the map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.destination is UINavigationController
        {
            let spotNumber = String(format: "%04d", (self.numSpots - 1))
            self.ref.child("Spots").child("Spot-0x" + spotNumber).setValue(["title": self.title])
            self.ref.child("Spots/Spot-0x\(spotNumber)/address").setValue(self.address)
            let coordinates = String(location.latitude) + "," + String(location.longitude)
            self.ref.child("Spots/Spot-0x\(spotNumber)/location").setValue(coordinates)
        }*/
    }
    
    //Literally just the segue
    @IBAction func continueButton(_ sender: Any) {
        performSegue(withIdentifier: "BackHome", sender: self.spot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
