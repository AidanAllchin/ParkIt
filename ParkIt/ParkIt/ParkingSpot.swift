
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
    var address: String
    //let locationName: String
    var isAvailable: Bool
    var coordinate: CLLocationCoordinate2D
    var periods: [[Int]]
    var timeLeft: Float
    var userBuying: String?
    var userSelling: String
    
    init(title: String, address: String, isAvailable: Bool, coordinate: CLLocationCoordinate2D, periods: [[Int]], timeLeft: Float, userBuying: String, userSelling: String) {
        
        self.title = title
        self.address = address
        //self.locationName = locationName
        self.isAvailable = isAvailable
        self.coordinate = coordinate
        self.periods = periods
        self.timeLeft = timeLeft
        self.userBuying = userBuying
        self.userSelling = userSelling
        
        super.init()
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
        return "Time left: " + String(timeLeft) + "\nUser Selling: " + String(userSelling)
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: address]
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

