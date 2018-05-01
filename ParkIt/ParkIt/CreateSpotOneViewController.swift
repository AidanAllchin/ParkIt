//
//  CreateSpotOneViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 5/1/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CreateSpotOneViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var newSpot: ParkingSpot = ParkingSpot()
    
    let regionRadius: CLLocationDistance = 1000
    var locationManager:CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }

    func centerMapOnLocation(location: MKUserLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        currentLocation = CLLocationCoordinate2D(latitude: (userLocation.coordinate.latitude), longitude: (userLocation.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //To send the ParkingSpot to the next page of creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreateSpotTwoViewController
        {
            let vc = segue.destination as? CreateSpotTwoViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        newSpot.coordinate = currentLocation
        performSegue(withIdentifier: "NextCreatePage", sender: self.newSpot)
    }
}
