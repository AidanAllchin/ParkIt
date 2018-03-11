
//  Created by Will Frohlich on 3/2/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit
import Contacts
import Firebase

//creating a class for artwork objects
class ParkingSpot: NSObject, MKAnnotation {
    //var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var title: String?
    let locationName: String
    var isAvailable: Bool
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, isAvailable: Bool, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.locationName = locationName
        self.isAvailable = isAvailable
        self.coordinate = coordinate
        
        //ref = Database.database().reference()
        
        super.init()
    }
    
    init?(spot: DatabaseReference) {
        /*databaseHandle = ref?.child("Spots").child("Spot-0x0000").observe(.childAdded, with: { (snapshot) in
            let title = snapshot.value as? String
        }*/
        
        //databaseHandle = ref?.child("Spots").child("Spot-0x0000")

        
        self.title = "No Title"
        self.locationName = "No Name"
        self.isAvailable = true
        self.coordinate = CLLocationCoordinate2D()
        
        /*ref?.child("Spots").child("Spot-0x0000").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? Int ?? 1
            if postDict == 1
            {
                self.isAvailable = true
            }
            else
            {
                self.isAvailable = false
            }
        })*/
        
        /*ref?.child("Spots").child("Spot-0x0000").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [Double] ?? [50.0, 50.0]
            self.coordinate = CLLocationCoordinate2D(latitude: postDict[0], longitude: postDict[1])
            
        })*/
        
        // 1
        //self.title = json[16] as? String ?? "No Title"
        //self.locationName = json[12] as! String
        //self.locationName = json[11] as! String
        //self.discipline = json[15] as! String
        //self.isAvailable = true
        // 2
        /*if let latitude = Double(json[18] as! String),
            let longitude = Double(json[19] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }*/
    }
    
    // markerTintColor for if the spot is open or not
    var markerTintColor: UIColor  {
        if(isAvailable)
        {
            return .blue
        }
        else
        {
            return .red
        }
    }


    
    var subtitle: String? {
        return locationName
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    var imageName: String? {
        //if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }

}

