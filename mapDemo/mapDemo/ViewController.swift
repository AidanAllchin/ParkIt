//
//  ViewController.swift
//  mapDemo
//
//  Created by Will Frohlich on 2/8/18.
//  Copyright © 2018 Will Frohlich. All rights reserved.
//

import UIKit
import MapKit

final class SchoolAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    var region: MKCoordinateRegion{
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let mitCoordinate = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0942)
        let mitAnnotation = SchoolAnnotation(coordinate: mitCoordinate, title: "MIT", subtitle: "MIT is wack")
        mapView.addAnnotation(mitAnnotation)
        mapView.setRegion(mitAnnotation.region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController: MKMapViewDelegate{
    func mapView(_mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if let schoolAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
            schoolAnnotationView.animatesWhenAdded = true
            schoolAnnotationView.titleVisibility = .adaptive
        
            return schoolAnnotationView
        }
        
        return nil
    }
}
