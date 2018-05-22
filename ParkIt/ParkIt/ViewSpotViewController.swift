//
//  ViewSpotViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 4/16/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import MapKit

class ViewSpotViewController: UIViewController {

    @IBOutlet weak var spotOptions: UIButton!
    @IBOutlet weak var spotTitle: UILabel!
    @IBOutlet weak var spotLabel: UILabel!
    @IBOutlet weak var userSellingLabel: UILabel!
    var spot:ParkingSpot = ParkingSpot()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:))
        
        spotTitle?.text = spot.title
        spotLabel?.text = spot.address
        userSellingLabel?.text = spot.userSelling
        spotOptions.isHidden = true
        
        if (spot.userSelling == (UserDefaults.standard.value(forKey: "userEmail") as! String))
        {
            spotOptions.isHidden = false
        }
        
    }
    
    @IBAction func getDirections(_ sender: Any) {
        let coordinate = spot.coordinate
        let regionDistance:CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = spot.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Segue that transfers information about the spot to viewspotcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BuySpotViewController
        {
            //vc = instance of BuySpotViewController
            let vc = segue.destination as? BuySpotViewController
            //Set the spot variable of the BuySpotViewController to self.spot
            vc!.spot = sender as! ParkingSpot
            print("test")
        }
    }
    
    @IBAction func buySpot(_ sender: Any) {
        performSegue(withIdentifier: "BuySpotSegue", sender: self.spot)
    }
}
