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

    @IBOutlet weak var periodSwitcher: UISegmentedControl!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var spotLabel: UILabel!
    var spot:ParkingSpot = ParkingSpot()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotLabel?.text = spot.address
        var start1:String
        var end1:String
        var price1 = String(spot.periods[0][2])
        if(spot.periods[0][0] > 12)
        {
            start1 = String(spot.periods[0][0] - 12) + " p.m."
        }
        else
        {
            start1 = String(spot.periods[0][0])
        }
        if(spot.periods[0][1] > 12)
        {
            end1 = String(spot.periods[0][1] - 12) + " p.m."
        }
        else
        {
            end1 = String(spot.periods[0][1])
        }
        startTimeLabel?.text = start1
        endTimeLabel?.text = end1
        startTimeLabel.sizeToFit()
        endTimeLabel.sizeToFit()

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
        if segue.destination is ViewSpotViewController
        {
            let vc = segue.destination as? ViewSpotViewController
            vc?.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func buySpot(_ sender: Any) {
        performSegue(withIdentifier: "BuySpotSegue", sender: self.spot)
    }
    
}
