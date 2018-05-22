//
//  MapViewController.swift
//  ParkIt
//
//  Created by Will Frohlich on 2/13/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import Foundation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class MapViewController: UIViewController, MKMapViewDelegate {
    
    var isSideBarHidden = true
    var selectedPin:MKPlacemark? = nil
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var parkingspots: [ParkingSpot] = []
    let regionRadius: CLLocationDistance = 300
    @IBOutlet weak var mapView: MKMapView!
    
    //keep UISearch bar in memory
    var resultSearchController:UISearchController? = nil
    
    @IBOutlet var sideBarConstraint: NSLayoutConstraint!
    @IBOutlet var blur: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    //Sidebar code
    @IBOutlet weak var sideBar: UIView!
    
    @IBAction func openSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        openSideBar()
    }
    
    @IBAction func closeSwipe(_ sender: UISwipeGestureRecognizer) {
        if isSideBarHidden{
            closeSideBar()
        }
    }
    
    @IBAction func sideBarButtonPressed(_ sender: AnyObject) {
        if isSideBarHidden {
            openSideBar()
        }
        else {
            closeSideBar()
        }
        isSideBarHidden = !isSideBarHidden
    }
    
    func openSideBar() {
        sideBarConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.blur.effect = self.effect
        })
    }
    
    func closeSideBar() {
        sideBarConstraint.constant = -160
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.blur.effect = nil
        })
    }
    
    //Logs out when logout button pressed
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(nil, forKey: "userEmail")
            performSegue(withIdentifier: "gotoLogin", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        //removes blur at initialization of page
        effect = blur.effect
        blur.effect = nil
        
        //Instantiates the Search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for parking"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        ref = Database.database().reference()
        
        //set initial location to Seattle... change to user location eventually
        let initialLocation = CLLocation(latitude: 47.6062, longitude: -122.3321)
        //call zoom in function
        centerMapOnLocation(location: initialLocation)
        
        //setting ViewController as the delegate of the map view.
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
        
        mapView.register(ParkingSpotMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        //Loads in the annotations!
        loadInitialData()
        mapView.addAnnotations(parkingspots)
    }
    
    
    //Zoom in button(re center)
    @IBAction func zoomIn(_ sender: Any) {
       mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
    }
    
    //Grabs every ParkingSpot from database and adds them to the map as annotations
    func loadInitialData() {
        var numSpots: Int = 0
        var spotName: String = ""
        
        var title: String = ""
        var address: String = ""
        var isAvailable: Bool = true
        var uniqueId: String = "0"
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var timeLeft: Float = 0.0
        var userBuying: String = ""
        var userSelling: String = ""
        var timesAvailable: [String] = [String]()
        var reservations: [String] = [String]()
        
        //title
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            numSpots = spots.count
            var currentSpotNum = numSpots - 1
            
            //Start cycling through all the spots and get their info from Firebase.Database
            let jj = 0
            while jj <= currentSpotNum
            {
                spotName = "Spot-0x" + String(format: "%04d", currentSpotNum)
                
                //Now we know which spot we're accessing, we can get all the information for it...
                let dict: NSDictionary = spots.value(forKey: spotName) as! NSDictionary
                title = dict.value(forKey: "title") as! String
                
                address = dict.value(forKey: "address") as! String
                
                //isAvailable
                let temp = dict.value(forKey: "isAvailable") as! Int
                if(temp == 1) {
                    isAvailable = true
                } else {
                    isAvailable = false
                }
                
                //uniqueId
                uniqueId = dict.value(forKey: "id") as! String
                
                //location
                var locCompString = ""
                locCompString = dict.value(forKey: "location") as! String
                let coordArr = locCompString.components(separatedBy: ", ")
                
                location = CLLocationCoordinate2D(latitude: Double(coordArr[0])!, longitude: Double(coordArr[1])!)
                
                //timeLeft
                timeLeft = dict.value(forKey: "timeLeft") as! Float
                
                //userBuying
                userBuying = dict.value(forKey: "userBuying") as! String
                
                //userSelling
                userSelling = dict.value(forKey: "userSelling") as! String
                
                //timesAvailabe
                let timesDict = dict.value(forKey: "TimesAvailable") as! NSDictionary
                
                let timesCount = timesDict.count
                
                var ii = 0
                while ii < timesCount
                {
                    let timeName: String = "Time-" + String(format: "%02d", (ii))
                    let currentTime = timesDict.value(forKey: timeName)
                    timesAvailable.append(currentTime as! String)
                    
                    ii = ii + 1
                }
                
                //reservations
                //Make it so spots don't have to have a reservation to load
                if let resDict: NSDictionary = dict.value(forKey: "Reservations") as? NSDictionary
                {
                    let resCount = resDict.count
                    
                    var jj = 0
                    while jj < resCount
                    {
                        let resName: String = "Res-" + String(format: "%02d", (jj))
                        let currentRes = resDict.value(forKey: resName)
                        reservations.append(currentRes as! String)
                        
                        jj = jj + 1
                    }
                }
                
                let currentSpot: ParkingSpot = ParkingSpot(title: title, address: address, isAvailable: isAvailable, uniqueId: uniqueId, coordinate: location, timeLeft: timeLeft, userBuying: userBuying, userSelling: userSelling, timesAvailable: timesAvailable, reservations: reservations)
                
                self.mapView.addAnnotation(currentSpot)
                
                currentSpotNum = currentSpotNum - 1
            }
        })
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            //Code
        //})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    //Function which zooms in on passed in location
    //1000 is about a half mile
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Acessing user lcation
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }


    //Segue that transfers information about the spot to viewspotcontroller
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController
        {
            let vc = segue.destination as? ViewSpotViewController
            vc?.spot = sender as! ParkingSpot
        }
    }

    //Preforming the above segue
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "ViewSpotFromAnnotation", sender: view.annotation as! ParkingSpot)
        }
}

//Zoom in on the location searched for in the table view
extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

//calls the dropPinZoomIn function for the selected location in the tableview
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
