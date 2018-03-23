import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import Foundation


class MapViewController: UIViewController, MKMapViewDelegate {

        @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    //Initialize all the artwork pieces!
    var parkingspots: [ParkingSpot] = []
    let regionRadius: CLLocationDistance = 300
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    
    print (ref)
    
    //  set initial location to Seattle... change to user location eventually
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
                
                let currentSpot: ParkingSpot = ParkingSpot(title: title, address: address, isAvailable: isAvailable, coordinate: location, periods: period, timeLeft: timeLeft, userBuying: userBuying, userSelling: userSelling)
                
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        searchBar.resignFirstResponder()
    }

}



extension ViewController: MKMapViewDelegate {
    //launches Apple Maps!
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "ViewSpotFromAnnotation", sender: self)
       // let location = view.annotation as! ParkingSpot
        //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        //location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
