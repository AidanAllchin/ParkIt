//
//  Created by Will Frohlich on 3/6/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import Foundation
import MapKit

class ParkingSpotMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let parkingspot = newValue as? ParkingSpot else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //apple maps button
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 40, height: 40)))
            mapsButton.setBackgroundImage(UIImage(named: "info"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            // 2
            markerTintColor = parkingspot.markerTintColor
            let detailLabel = UILabel()
            //Label on the annotation
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            //detailLabel.text = parkingspot.subtitle
            detailCalloutAccessoryView = detailLabel
            
        }
    }
}
