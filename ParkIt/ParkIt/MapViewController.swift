//
//  MapViewController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 2/13/18.
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
    
    //WIll A please comment your code
    func openSideBar() {
        sideBarConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations:  { self.view.layoutIfNeeded() })
    }
    
    func closeSideBar() {
        sideBarConstraint.constant = -160
        UIView.animate(withDuration: 0.3, animations:  { self.view.layoutIfNeeded() })
    }
    
    
    override func viewDidLoad() {
    
    super.viewDidLoad()
    
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
    
    print (ref)
    
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
    
    
    //loads in the locations and their stuff
    func loadInitialData() {
        var numSpots: Int = 0
        var spotName: String = ""
        
        var title: String = ""
        var address: String = ""
        var isAvailable: Bool = true
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var periodCount: Int = 0
        var period: [[Int]] = [[Int]]()
        var timeLeft: Float = 0.0
        var userBuying: String = ""
        var userSelling: String = ""
        let spotsAlwaysAvaliable: [String] = [String]()
        
        //title
        ref?.observe(.value, with: { (snapshot) in
            //We determine how many spots there are in the database and set the name of the spot
            let wholeDatabase: NSDictionary = snapshot.value as! NSDictionary
            let spots: NSDictionary = wholeDatabase.value(forKey: "Spots") as! NSDictionary
            
            numSpots = spots.count
            var currentSpotNum = numSpots - 1
            
            //Start cycling through all the spots and get their info from Firebase.Database
            let jj = 0
            while jj <= currentSpotNum
            {
                period = [[Int]]()
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
                
                //location
                var locCompString = ""
                locCompString = dict.value(forKey: "location") as! String
                let coordArr = locCompString.components(separatedBy: ", ")
                
                location = CLLocationCoordinate2D(latitude: Double(coordArr[0])!, longitude: Double(coordArr[1])!)
                
                //Periods
                let periodsTempDict = dict.value(forKey: "Periods") as! NSDictionary
                
                //periodCount
                periodCount = periodsTempDict.count
                
                //Individual periods
                var ii = 0
                while ii < periodCount
                {
                    let periodName: String = "Period-0x000" + String(ii)
                    var periodArray: [Int] = [Int]()
                    
                    var perCompString = ""
                    let periodTempDict = periodsTempDict.value(forKey: periodName) as! NSDictionary
                    perCompString = periodTempDict.value(forKey: "openHours") as! String
                    
                    let tempArray = perCompString.components(separatedBy: ",")
                    periodArray.append(Int(tempArray[0])!)
                    periodArray.append(Int(tempArray[1])!)
                    
                    periodArray.append(Int(periodTempDict.value(forKey: "price") as! Int))
                    
                    period.append(periodArray)
                    
                    ii = ii + 1
                }
                
                //timeLeft
                timeLeft = dict.value(forKey: "timeLeft") as! Float
                
                //userBuying
                userBuying = dict.value(forKey: "userBuying") as! String
                
                //userSelling
                userSelling = dict.value(forKey: "userSelling") as! String
                
                let currentSpot: ParkingSpot = ParkingSpot(title: title, address: address, isAvailable: isAvailable, coordinate: location, periods: period, timeLeft: timeLeft, userBuying: userBuying, userSelling: userSelling, spotsAlwaysAvaliable: spotsAlwaysAvaliable)
                
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
