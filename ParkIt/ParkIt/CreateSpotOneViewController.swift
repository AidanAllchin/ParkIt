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
    
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        mapView.mapType = .hybrid

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
        
        centerMapOnLocation(currentLocation, mapView: mapView)
        
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 50
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
        if(addressField.text != "")
        {
            newSpot.address = addressField.text!
            locationManager.stopUpdatingLocation()
            newSpot.coordinate = currentLocation
            performSegue(withIdentifier: "NextCreatePage", sender: self.newSpot)
        }
        else
        {
            let alert = UIAlertController(title: "Address Missing", message: "Please enter an address before continuing", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    //Gets rid of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        addressField.resignFirstResponder()
    }
}
