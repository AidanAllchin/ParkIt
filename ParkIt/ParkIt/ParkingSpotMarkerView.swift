//  Custom annotation for each ParkingSpot with the spot.title attribute in the label, and an info button linking to ViewSpotViewController
//  Created by Will Frohlich on 3/6/18.
//  Copyright © 2018 ParkIt. All rights reserved.
//

import Foundation
import MapKit

class ParkingSpotMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let parkingspot = newValue as? ParkingSpot else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            
            let infoButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 40, height: 40)))
            infoButton.setBackgroundImage(UIImage(named: "info"), for: UIControlState())
            rightCalloutAccessoryView = infoButton
            
            markerTintColor = parkingspot.markerTintColor
            let detailLabel = UILabel()
            //Label on the annotation
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailCalloutAccessoryView = detailLabel
            
        }
    }
}
