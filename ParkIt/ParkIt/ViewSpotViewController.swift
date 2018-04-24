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

    
    @IBOutlet weak var spotLabel: UILabel!
    var spot:ParkingSpot = ParkingSpot()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        spotLabel?.text = spot.address
        

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
    
}