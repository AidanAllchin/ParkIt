/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBAction func onGoButton(_ sender: Any) {
        performSegue(withIdentifier: "toBuySpot", sender: self)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    //Initialize all the artwork pieces!
    var parkingspots: [ParkingSpot] = []
    let regionRadius: CLLocationDistance = 1000
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    
    //  set initial location to Seattle... change to user location eventually
    let initialLocation = CLLocation(latitude: 47.6062, longitude: -122.3321)
    //call zoom in function
    centerMapOnLocation(location: initialLocation)
    
    //setting ViewController as the delegate of the map view.
    mapView.delegate = self
    mapView.showsUserLocation = true
    
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
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance((userLocation.location?.coordinate)!, regionRadius, regionRadius)
        
        mapView.setRegion(region, animated: true)
    }
    
    //loads in the locations and their stuff
    func loadInitialData() {
        var title: String = ""
        var isAvailable: Bool = true
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var period: [[String]] = [[String]]()
        var timeLeft: Double = 0.0
        var userBuying: String = ""
        var userSelling: String = ""
        
        //title
        ref?.child("Spots").child("Spot-0x0000").child("title").observe(.value, with: { (snapshot) in
            //Code
            title = snapshot.value as! String
            
            print(snapshot.value!)
        })
        
        //isAvailable
        ref?.child("Spots").child("Spot-0x0000").child("isAvailable").observe(.value, with: { (snapshot) in
            let temp = snapshot.value as! Int
            if(temp == 1) {
                isAvailable = true
            } else {
                isAvailable = false
            }
        })
        
        //location
        ref?.child("Spots").child("Spot-0x0000").child("location").observe(.value, with: { (snapshot) in
            //Code
            var test = ""
            test = snapshot.value as! String
            let coordArr = test.components(separatedBy: ", ")
            
            location = CLLocationCoordinate2D(latitude: Double(coordArr[0])!, longitude: Double(coordArr[1])!)
            
            print(snapshot.value!)
        })
        
        //timeLeft
        ref?.child("Spots").child("Spot-0x0000").child("timeLeft").observe(.value, with: { (snapshot) in
            //Code
            timeLeft = snapshot.value as! Double
        })
        
        //userBuying
        ref?.child("Spots").child("Spot-0x0000").child("userBuying").observe(.value, with: { (snapshot) in
            //Code
            userBuying = snapshot.value as! String
        })
        
        //userSelling
        ref?.child("Spots").child("Spot-0x0000").child("userSelling").observe(.value, with: { (snapshot) in
            //Code
            userSelling = snapshot.value as! String
        })
        
        
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

