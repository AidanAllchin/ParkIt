//
//  CalendarController.swift
//  ParkIt
//
//  Created by Aidan Allchin on 5/3/18.
//

import Foundation
import UIKit

class CalendarController: NSObject, UITableViewDelegate, UITableViewDataSource {
    var times: [String]
    
    init(times: [String]) {
        self.times = times
        
        /*for time in times {
         reloadData()
         }*/
        //for times.count, create a TimeCell with times[i] as the label
    }
    
    //required init?(coder aDecoder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(times[indexPath.row])"
        return cell
    }
}
