//
//  ParkingSpot.Swift
//  ParkIt
//
//  Created by Will Frohlich on 3/2/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import Foundation
import MapKit
import Contacts
import Firebase

//ParkingSpot object
class ParkingSpot: NSObject, MKAnnotation {
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
    var reservations: NSDictionary
    
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
        self.reservations = NSDictionary()
        
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
        self.reservations = NSDictionary()
    }
    
    init(dict: NSDictionary)
    {
        self.title = dict.value(forKey: "title") as? String
        self.address = dict.value(forKey: "address") as! String
        
        let availableNum = dict.value(forKey: "isAvailable") as! Int
        if (availableNum == 0) { self.isAvailable = false } else { self.isAvailable = true}
        self.uniqueId = dict.value(forKey: "id") as! String
        let coords: String = dict.value(forKey: "location") as! String
        let coordsArray = coords.components(separatedBy: ", ")
        self.coordinate = CLLocationCoordinate2D(latitude: Double(coordsArray[0])!, longitude: Double(coordsArray[1])!)
        self.timeLeft = dict.value(forKey: "timeLeft") as! Float
        self.userBuying = dict.value(forKey: "userBuying") as? String
        self.userSelling = dict.value(forKey: "userSelling") as! String
        var timesArray = [String]()
        for time in dict.value(forKey: "TimesAvailable") as! NSDictionary
        {
            timesArray.append(time.value as! String)
        }
        self.timesAvailable = timesArray
        
        var finalReservations = NSDictionary()
        if let resDict: NSDictionary = dict.value(forKey: "Reservations") as? NSDictionary
        {
            /*var resCount = 0
            let resIdArray = resDict.allKeys as! [String]
            while resCount < resDict.count
            {
                let reservation = resDict.value(forKey: resIdArray[resCount])
                for res in resDict
                {
                    resArray.append(res.value as! String)
                }
            }*/
            finalReservations = resDict
        }
        self.reservations = finalReservations
    }
    
    init(title: String, address: String, isAvailable: Bool, uniqueId: String, coordinate: CLLocationCoordinate2D, timeLeft: Float, userBuying: String, userSelling: String, timesAvailable: [String], reservations: NSDictionary) {
        
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
    
    // markerTintColor depending on spot availability
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
    
    //Creating the subtitle
    var subtitle: String? {
        return "Time left: " + String(timeLeft) + "\nUser Selling: " + String(userSelling)
    }
}
