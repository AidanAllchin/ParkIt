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

//The first view controller in the create spot sequence: Opens a map with user location and asks user to enter an address.

class CreateSpotOneViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var newSpot: ParkingSpot = ParkingSpot()
    let regionRadius: CLLocationDistance = 1000
    var locationManager:CLLocationManager!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet var CreateOneView: UIView!
    
    //The constraints for the bottom and top of the text field
    @IBOutlet var textBottomConstraint: NSLayoutConstraint!
    @IBOutlet var textTopConstraint: NSLayoutConstraint!

    //Blur effect for when text field is pressed
    @IBOutlet var blur: UIVisualEffectView!
    var effect:UIVisualEffect!

    //A function that moves the text field when it is being edited
    @IBAction func moveTextFieldOnEdit(_ sender: UITextField) {
        //Disables the constraint connecting the text to the bottom of the view and enables the constraint
        //connecting it to the top of the view
        NSLayoutConstraint.deactivate([textBottomConstraint])
        NSLayoutConstraint.activate([textTopConstraint])

        //Moves the text field to the top
        textTopConstraint.constant = 32
        //Animates the change as well as bringing the blur to front
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.CreateOneView.bringSubview(toFront: self.blur)
        })
    }
    
    //Moves text field back after editing has ended
    @IBAction func editingEnded(_ sender: UITextField) {
        //Disables the constraint connecting the text to the Top of the view and enables the constraint
        //connecting it to the bottom of the view
        NSLayoutConstraint.deactivate([textTopConstraint])
        NSLayoutConstraint.activate([textBottomConstraint])
        //Animates The change as well as pushing the blur to the back
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.CreateOneView.sendSubview(toBack: self.blur)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        mapView.mapType = .hybrid
        //Deactivates the top constraint
        NSLayoutConstraint.deactivate([textTopConstraint])
        //Creates the delegate for the text field
        self.addressField.delegate = self
        //Sends blur to back
        self.CreateOneView.sendSubview(toBack: self.blur)
    }
    
    //This function closes the keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //closes keyboard
        addressField.resignFirstResponder()
        return (true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    
    //gets user's current location.
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    //Centers map on user location
    func centerMapOnLocation(location: MKUserLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Constantly center the map on the users location so user can't zoom out
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        currentLocation = CLLocationCoordinate2D(latitude: (userLocation.coordinate.latitude), longitude: (userLocation.coordinate.longitude))
        centerMapOnLocation(currentLocation, mapView: mapView)
        
    }
    
    //General center map on location function
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
    
    //Prepare to send the unfinished ParkingSpot to the next page of creation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CreateSpotTwoViewController
        {
            let vc = segue.destination as? CreateSpotTwoViewController
            vc!.spot = sender as! ParkingSpot
        }
    }
    
    //Segue button to next page
    @IBAction func nextButton(_ sender: Any) {
        if(addressField.text != "")
        {
            //set some of the parkingspots traits and pass the parking spot to the next page.
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
