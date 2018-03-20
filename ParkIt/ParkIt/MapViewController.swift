import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import Foundation


class MapViewController: UIViewController, MKMapViewDelegate {
    @IBAction func onGoButton(_ sender: Any) {
        performSegue(withIdentifier: "toBuySpot", sender: self)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func ViewSpot(_ sender: Any) {
        self.performSegue(withIdentifier: "toViewSpot", sender:nil);
    }
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    //Initialize all the artwork pieces!
    var parkingspots: [ParkingSpot] = []
    let regionRadius: CLLocationDistance = 300
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    //ref.child("Spots").child("Spot-0x0000").child("title").setValue("stupid")
    /*ref.child("Spots").child("Spot-0x0000").child("title").observe(.value, with: { (snapshot) in
        //Code
        if snapshot.value is NSNull {
            print("snapshot does not exist")
        } else {
            print("snapshot exists")
        }
        var title = snapshot.value as! String
        
        print(snapshot.value!)
    }) { (error) in
        print(error.localizedDescription)
    }*/
    
    print (ref)
    
    //  set initial location to Seattle... change to user location eventually
    let initialLocation = CLLocation(latitude: 47.6062, longitude: -122.3321)
    //call zoom in function
    centerMapOnLocation(location: initialLocation)
    
    //setting ViewController as the delegate of the map view.
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    
    //Create an artwork point
    //let artwork = Artwork(title: "King David Kalakaua",locationName: "Waikiki Gateway Park",discipline: "Sculpture",coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
      //  mapView.addAnnotation(artwork)
    
    mapView.register(ParkingSpotMarkerView.self,
                     forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    

    //Loads in the annotations!
    loadInitialData()
    mapView.addAnnotations(parkingspots)
    }
    
    @IBAction func zoomIn(_ sender: Any) {
       mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    //loads in the locations and their stuff
    func loadInitialData() {
        var numSpots: Int = 0
        var spotName: String = ""
        
        var title: String = ""
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
            
            let numSpots = wholeDatabase.value(forKey: "spotCount") as! Int
            var currentSpotNum = numSpots - 1
            
            
            let jj = 0
            while jj < currentSpotNum
            {
                spotName = "Spot-0x" + String(format: "%04d", currentSpotNum)
                
                //Now we know which spot we're accessing, we can get all the information for it...
                let dict: NSDictionary = spots.value(forKey: spotName) as! NSDictionary
                title = dict.value(forKey: "title") as! String
                
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
                
                //periodCount
                periodCount = dict.value(forKey: "periodCount") as! Int
                
                //Periods
                var ii = 0
                while ii < periodCount
                {
                    let periodName: String = "Period-0x000" + String(ii)
                    var periodArray: [Int] = [Int]()
                    
                    var perCompString = ""
                    let periodsTempDict = dict.value(forKey: "Periods") as! NSDictionary
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
                
                let currentSpot: ParkingSpot = ParkingSpot(title: title, isAvailable: isAvailable, coordinate: location, periods: period, timeLeft: timeLeft, userBuying: userBuying, userSelling: userSelling)
                
                self.mapView.addAnnotation(currentSpot)
                
                currentSpotNum = currentSpotNum - 1
            
            }
            
        })
        //parkingspots.append(currentSpot)
        //mapView.addAnnotations(parkingspots)
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
    // 1
    //func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2 Checks to make sure the annotation to animate is an Artwork annotation
        //Must change later!
        //guard let annotation = annotation as? Artwork else { return nil }
        // 3
       // let identifier = "marker"
       // var view: MKMarkerAnnotationView
        // 4
       // if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        //    as? MKMarkerAnnotationView {
        //    dequeuedView.annotation = annotation
         //   view = dequeuedView
       // } else {
            // 5
         //   view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
         //   view.canShowCallout = true
         //   view.calloutOffset = CGPoint(x: -5, y: 5)
         //   view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        //}
       // return view
    //}
    
    
    //launches apple maps!
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ParkingSpot
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
}

