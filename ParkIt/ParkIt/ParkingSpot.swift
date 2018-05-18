//
//  Created by Will Frohlich on 3/2/18.
//  
//

import Foundation
import MapKit
import Contacts
import Firebase

class ParkingSpot: NSObject, MKAnnotation {
    //var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var title: String?
    var address: String
    var isAvailable: Bool
    var uniqueId: String
    var coordinate: CLLocationCoordinate2D
    var timeLeft: Float
    var userBuying: String?
    var userSelling: String
    var timesAvailable: [String]
    var reservations: [String]
    
    override init()
    {
        self.title = ""
        self.address = ""
        self.isAvailable = false
        self.uniqueId = "0"
        self.coordinate = CLLocationCoordinate2D()
        self.timeLeft = 0.0
        self.userBuying = ""
        self.userSelling = ""
        self.timesAvailable = [String]()
        self.reservations = [String]()
        
        super.init()
    }
    
    init(title: String)
    {
        self.title = ""
        self.address = ""
        self.isAvailable = false
        self.uniqueId = "0"
        self.coordinate = CLLocationCoordinate2D()
        self.timeLeft = 0.0
        self.userBuying = ""
        self.userSelling = ""
        self.timesAvailable = [String]()
        self.reservations = [String]()
    }
    
    init(title: String, address: String, isAvailable: Bool, uniqueId: String, coordinate: CLLocationCoordinate2D, timeLeft: Float, userBuying: String, userSelling: String, timesAvailable: [String], reservations: [String]) {
        
        self.title = title
        self.address = address
        self.isAvailable = isAvailable
        self.uniqueId = uniqueId
        self.coordinate = coordinate
        self.timeLeft = timeLeft
        self.userBuying = userBuying
        self.userSelling = userSelling
        self.timesAvailable = timesAvailable
        self.reservations = reservations
        
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
    
    var imageName: String? {
        //if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }

}

