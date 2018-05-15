//
//  ViewSpotViewController.swift
//  ParkIt
//  *** CONSIDER REPLACING WITH BUTTONS FOR EACH PERIOD THAT THE USER CAN SELECT ***
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
    
    //the start time of the spot period
    var start:String = ""
    //the end time of the spot period
    var end:String = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:))
        
            
        spotLabel?.text = spot.address
        
//        let periodNum = spot.periods.count
//
//        //Deletes the default 2 segments
//        periodSwitcher.removeAllSegments()
//
//        //If there's only one period for the spot, don't show a switcher
//        if(periodNum == 1)
//        {
//            periodSwitcher.isHidden = true
//        }
//        else
//        {
//            var i = 0
//            while(i < periodNum)
//            {
//                periodSwitcher.insertSegment(withTitle: "Period " + String(i + 1), at: i, animated: true)
//                i = i + 1
//            }
//            periodSwitcher.selectedSegmentIndex = 0
//        }
//
//        //Select the first period by default
//        var j = 0
//        if(periodSwitcher.numberOfSegments != 0)
//        {
//            j = periodSwitcher.selectedSegmentIndex
//        }
//
//        //Change the periods to a user-friendly time format
//        if(spot.periods[j][0] > 12)
//        {
//            start = String(spot.periods[j][0] - 12) + " p.m."
//        }
//        else if(spot.periods[j][0] < 12)
//        {
//            start = String(spot.periods[j][0]) + " a.m."
//        }
//        else
//        {
//            start = String(spot.periods[j][0]) + " p.m."
//        }
//        if(spot.periods[j][1] > 12)
//        {
//            end = String(spot.periods[j][1] - 12) + " p.m."
//        }
//        else if(spot.periods[j][1] < 12)
//        {
//            end = String(spot.periods[j][1]) + " a.m."
//        }
//        else
//        {
//            end = String(spot.periods[j][1]) + " p.m."
//        }
//
//        var price = String(spot.periods[0][2])
//
//        //Setting the text itself
//        startTimeLabel?.text = start
//        endTimeLabel?.text = end
//        startTimeLabel.sizeToFit()
//        endTimeLabel.sizeToFit()
//    }
//
//    //When the selected period changes, this code runs and changes the time it's available
//    @IBAction func periodSwitched(_ sender: UISegmentedControl) {
//        var j = 0
//        if(periodSwitcher.numberOfSegments != 0)
//        {
//            j = periodSwitcher.selectedSegmentIndex
//        }
//
//        if(spot.periods[j][0] > 12)
//        {
//            start = String(spot.periods[j][0] - 12) + " p.m."
//        }
//        else if(spot.periods[j][0] < 12)
//        {
//            start = String(spot.periods[j][0]) + " a.m."
//        }
//        else
//        {
//            start = String(spot.periods[j][0]) + " p.m."
//        }
//        if(spot.periods[j][1] > 12)
//        {
//            end = String(spot.periods[j][1] - 12) + " p.m."
//        }
//        else if(spot.periods[j][1] < 12)
//        {
//            end = String(spot.periods[j][1]) + " a.m."
//        }
//        else
//        {
//            end = String(spot.periods[j][1]) + " p.m."
//        }
//
//        startTimeLabel?.text = start
//        endTimeLabel?.text = end
//        startTimeLabel.sizeToFit()
//        endTimeLabel.sizeToFit()
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
