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
    
    var selectedPin:MKPlacemark? = nil
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var parkingspots: [ParkingSpot] = []
    let regionRadius: CLLocationDistance = 300
    @IBOutlet weak var mapView: MKMapView!
    
    var accountSpots = [ParkingSpot]()
    var rentingSpots = [ParkingSpot]()
    var goToRes = false
    
    //keep UISearch bar in memory
    var resultSearchController:UISearchController? = nil
    
    //The left constraint of the side bar that is used to bring the sidebar on or off the page
    @IBOutlet var sideBarConstraint: NSLayoutConstraint!
    //The blur that is shown when the side bar is out
    @IBOutlet var blur: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    //Variable to track if side bar is open or not
    var isSideBarHidden = true
    
    //This is a tap gesture recognizer for clicking off the sidebar
    @IBOutlet var tap: UITapGestureRecognizer!
    
    //This is a swipe gesture recognizer for swiping off the sidebar
    @IBOutlet var closeSwipe: UISwipeGestureRecognizer!
    
    //Sidebar that controls sidebar as a view
    @IBOutlet weak var sideBar: UIView!
    
    //THis function is called when the button is pressed to open or close the sidebar
    @IBAction func sideBarButtonPressed(_ sender: AnyObject) {
        //if side bar is closed
        if isSideBarHidden {
            openSideBar()
        }
        //if side bar is open
        else {
            closeSideBar()
        }
        isSideBarHidden = !isSideBarHidden
    }
    
    @IBOutlet var MapViewView: UIView!
    
    //This function is called when a user taps outside of the sidebar while open
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        closeSideBar()
    }
    
    //This function is called when a user swipes outside of the sidebar while open
    @IBAction func onCloseSwipe(_ sender: UISwipeGestureRecognizer) {
        closeSideBar()
    }
    
    //This function opens the sidebar
    func openSideBar() {
        //Sets the left edge constraint to the left edge of the screen
        sideBarConstraint.constant = 0
        //Animates the constraint change as well as bring the blur to the front
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.MapViewView.bringSubview(toFront: self.blur)
        })
        //Enables the tap and swipe functionality to close the sidebar
        tap.isEnabled = true
        closeSwipe.isEnabled = true
    }
    
    //This function closes the side bar
    func closeSideBar() {
        //Sets the left edge constraint to a negative number, making the side bar invisible
        sideBarConstraint.constant = -160
        //Animates the constraint change as well as pushing the blur to the back
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.MapViewView.sendSubview(toBack: self.blur)
        })
        //Disables the tap and swipe functionality
        tap.isEnabled = false
        closeSwipe.isEnabled = false
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
        
        //Sets blur effect then sends it to the back
        effect = blur.effect
        self.MapViewView.sendSubview(toBack: self.blur)
        
        //disables the tap and swipe off of sidebar functionality
        tap.isEnabled = false
        closeSwipe.isEnabled = false
        
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
        
        //Gets the spots the user has created
        getAccountSpots()
        
        //Gets the spots the user has a rental slot on
        getResSpots()
    }
    
    
    //Zoom in button(re center)
    @IBAction func zoomIn(_ sender: Any) {
       mapView.userTrackingMode = MKUserTrackingMode(rawValue: 1)!
    }
    
    //Grabs every ParkingSpot from database and adds them to the map as annotations
    func loadInitialData() {
        var numSpots: Int = 0
        
        var idArray = [String]()
        
        var title: String = ""
        var address: String = ""
        var isAvailable: Bool = true
        var uniqueId: String = "0"
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var timeLeft: Float = 0.0
        var userBuying: String = ""
        var userSelling: String = ""
        var timesAvailable = [String]()
        var reservations = NSDictionary()
        
        //title
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            numSpots = spots.count
            
            //Array of all spot parents
            idArray = spots.allKeys as! [String]
            
            var currentSpotNum = 0
            while currentSpotNum < numSpots
            {
                let spot = spots.value(forKey: idArray[currentSpotNum]) as! NSDictionary
                
                //Now we know which spot we're accessing, we can get all the information for it...
                
                //title
                title = spot.value(forKey: "title") as! String
                
                //address
                address = spot.value(forKey: "address") as! String
                
                //isAvailable
                let temp = spot.value(forKey: "isAvailable") as! Int
                //converting from Int to Bool
                if(temp == 1) {
                    isAvailable = true
                } else {
                    isAvailable = false
                }
                
                //uniqueId (also the parent of the spot)
                uniqueId = idArray[currentSpotNum]
                
                //location
                var locationCompositeString = ""
                locationCompositeString = spot.value(forKey: "location") as! String
                //convert from comma-separated String to CLLocationCoordinate2D
                let coordArray = locationCompositeString.components(separatedBy: ", ")
                location = CLLocationCoordinate2D(latitude: Double(coordArray[0])!, longitude: Double(coordArray[1])!)
                
                //timeLeft
                timeLeft = spot.value(forKey: "timeLeft") as! Float
                
                //userBuying
                userBuying = spot.value(forKey: "userBuying") as! String
                
                //userSelling
                userSelling = spot.value(forKey: "userSelling") as! String
                
                //timesAvailable
                let timesDictionary = spot.value(forKey: "TimesAvailable") as! NSDictionary
                let timesCount = timesDictionary.count
                
                //create the nested dict of TimesAvailable
                var ii = 0
                timesAvailable = [String]()
                while ii < timesCount
                {
                    let timeName: String = "Time-" + String(format: "%02d", (ii))
                    let currentTime = timesDictionary.value(forKey: timeName)
                    timesAvailable.append(currentTime as! String)
                    
                    ii = ii + 1
                }
                
                //reservations
                reservations = NSDictionary()
                //this makes it so spots don't have to have a reservation to load
                if let reservationDictionary = spot.value(forKey: "Reservations") as? NSDictionary
                {
                    /*var reservationCount = 0
                    
                    let resArray = reservationDictionary.allKeys as! [String]

                    while reservationCount < reservationDictionary.count
                    {
                        let reservation = reservationDictionary.value(forKey: resArray[reservationCount]) as! NSDictionary
                        
                        reservations.append(reservation.value(forKey: "time") as! String)
                        
                        reservationCount = reservationCount + 1
                    }*/
                    reservations = reservationDictionary
                }
                
                //create a ParkingSpot with all that stuff
                let currentSpot = ParkingSpot(title: title, address: address, isAvailable: isAvailable, uniqueId: uniqueId, coordinate: location, timeLeft: timeLeft, userBuying: userBuying, userSelling: userSelling, timesAvailable: timesAvailable, reservations: reservations)
                
                //and finally add it to the map
                self.mapView.addAnnotation(currentSpot)
                
                currentSpotNum = currentSpotNum + 1
            }
        })
  }
    
    func getAccountSpots() {
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            let spots: NSDictionary = (snapshot.value as! NSDictionary).value(forKey: "Spots") as! NSDictionary
            

            let idArray = spots.allKeys as! [String]
            var currentSpotNum = 0
            
            //Start cycling through all the spots and find which one has the same id as the spot that was clicked on for purchase
            while currentSpotNum < spots.count
            {
                let spot = spots.value(forKey: idArray[currentSpotNum]) as! NSDictionary
                let userSelling = spot.value(forKey: "userSelling") as! String
                if (userSelling == UserDefaults.standard.value(forKey: "userEmail") as? String)
                {
                    self.accountSpots.append(ParkingSpot(dict: spot))
                }
                currentSpotNum = currentSpotNum + 1
            }
        })
    }
    
    func getResSpots() {
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            let spots: NSDictionary = (snapshot.value as! NSDictionary).value(forKey: "Spots") as! NSDictionary
            
            let idArray = spots.allKeys as! [String]
            var currentSpotNum = 0
            
            //Start cycling through all the spots, then once inside start cycling through each spot's reservations
            while currentSpotNum < spots.count
            {
                let spot = spots.value(forKey: idArray[currentSpotNum]) as! NSDictionary
                if let spotRes = spot.value(forKey: "Reservations") as? NSDictionary
                {
                    let resIdArray = spotRes.allKeys
                    var currentResNum = 0
                    
                    while currentResNum < resIdArray.count
                    {
                        let res = spotRes.value(forKey: resIdArray[currentResNum] as! String) as! NSDictionary
                        let userRenting = res.value(forKey: "userBuying") as! String
                        if (userRenting == UserDefaults.standard.value(forKey: "userEmail") as? String)
                        {
                            //this prevents spots from showing up more than once
                            var add = true
                            for rentSpot in self.rentingSpots
                            {
                                if (rentSpot.uniqueId == ParkingSpot(dict: spot).uniqueId)
                                {
                                    add = false
                                }
                            }
                            if add == true
                            {
                                self.rentingSpots.append(ParkingSpot(dict: spot))
                            }
                        }
                        currentResNum = currentResNum + 1
                    }
                }
                currentSpotNum = currentSpotNum + 1
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func goToAccount(_ sender: Any) {
        goToRes = false
        performSegue(withIdentifier: "ToAccountView", sender: self)
    }
    
    @IBAction func goToReservations(_ sender: Any) {
        goToRes = true
        performSegue(withIdentifier: "ToAccountView", sender: self)
    }
    
    //Segue that transfers information about the spot to viewspotcontroller
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewSpotViewController
        {
            let vc = segue.destination as? ViewSpotViewController
            vc?.spot = sender as! ParkingSpot
        }
        if segue.destination is Account2ViewController && goToRes == false
        {
            let vc = segue.destination as? Account2ViewController
            vc?.desc = "My reservations"
            vc?.tableContents = accountSpots
        }
        else if segue.destination is Account2ViewController && goToRes == true
        {
            let vc = segue.destination as? Account2ViewController
            vc?.desc = "My rentals"
            vc?.tableContents = rentingSpots
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
