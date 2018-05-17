//Wfrohllich


import Foundation
import UIKit

class ViewModelItem {
    private var item: Model
    
    var isSelected = false
    
    var title: String {
        return item.title
    }
    
    var isOpen: Bool{
        return item.isOpen
    }
    
    init(item: Model) {
        self.item = item
    }
}

class ViewModelTwo: NSObject {
    var items = [ViewModelItem]()
    var spot:ParkingSpot = ParkingSpot()
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }
    
    override init() {
        self.spot = ParkingSpot()
        super.init()
        getDataArray(spot: spot)
        //items = dataArray.map { ViewModelItem(item: $0) }
    }
    
    init(spot: ParkingSpot) {
        super.init()
        self.spot = ParkingSpot()
        getDataArray(spot: spot)
        //items = dataArray.map { ViewModelItem(item: $0) }
    }
    
    
    func getDataArray(spot: ParkingSpot) {
        var availableTimes: [String] = spot.timesAvailable
        var dataArray = [Model(title: "12:00 am", isOpen: false), Model(title: "12:30 am", isOpen: false), Model(title: "1:00 am", isOpen: false), Model(title: "1:30 am", isOpen: false), Model(title: "2:00 am", isOpen: false), Model(title: "2:30 am", isOpen: false), Model(title: "3:00 am", isOpen: false), Model(title: "3:30 am", isOpen: true), Model(title: "4:00 am", isOpen: false), Model(title: "4:30 am", isOpen: false), Model(title: "5:00 am", isOpen: false), Model(title: "5:30 am", isOpen: false), Model(title: "6:00 am", isOpen: false), Model(title: "6:30 am", isOpen: false), Model(title: "7:00 am", isOpen: false), Model(title: "7:30 am", isOpen: false), Model(title: "8:00 am", isOpen: false), Model(title: "8:30 am", isOpen: false), Model(title: "9:00 am", isOpen: false), Model(title: "9:30 am", isOpen: false), Model(title: "10:00 am", isOpen: false), Model(title: "10:30 am", isOpen: false), Model(title: "11:00 am", isOpen: false), Model(title: "11:30 am", isOpen: false), Model(title: "12:00 pm", isOpen: false), Model(title: "12:30 pm", isOpen: false), Model(title: "1:00 pm", isOpen: false), Model(title: "1:30 pm", isOpen: false), Model(title: "2:00 pm", isOpen: false), Model(title: "2:30 pm", isOpen: false), Model(title: "3:00 pm", isOpen: false), Model(title: "3:30 pm", isOpen: false), Model(title: "4:00 pm", isOpen: false), Model(title: "4:30 pm", isOpen: false), Model(title: "5:00 pm", isOpen: false), Model(title: "5:30 pm", isOpen: false), Model(title: "6:00 pm", isOpen: false), Model(title: "6:30 pm", isOpen: false), Model(title: "7:00 pm", isOpen: false), Model(title: "7:30 pm", isOpen: false), Model(title: "8:00 pm", isOpen: true), Model(title: "8:30 pm", isOpen: false), Model(title: "9:00 pm", isOpen: false), Model(title: "9:30 pm", isOpen: false), Model(title: "10:00 pm", isOpen: false), Model(title: "10:30 pm", isOpen: false), Model(title: "11:00 pm", isOpen: false), Model(title: "11:30 pm", isOpen: false)]
        
        //Set times back to 12-hour time before comparison
        var currentTime = 0
        while currentTime < availableTimes.count {
            if (availableTimes[currentTime].range(of: ":00") != nil ) {
                var hours = Int(availableTimes[currentTime].replacingOccurrences(of: ":00", with: ""))!
                if (hours > 12) {
                    hours = hours - 12
                    availableTimes[currentTime] = String(hours) + ":00"
                    availableTimes[currentTime] = availableTimes[currentTime] + " pm"
                }
                else {
                    availableTimes[currentTime] = String(hours) + ":00"
                    availableTimes[currentTime] = availableTimes[currentTime] + " am"
                }
            }
            else if (availableTimes[currentTime].range(of: ":30") != nil) {
                var hours = Int(availableTimes[currentTime].replacingOccurrences(of: ":30", with: ""))!
                if (hours > 12) {
                    hours = hours - 12
                    availableTimes[currentTime] = String(hours) + ":30"
                    availableTimes[currentTime] = availableTimes[currentTime] + " pm"
                }
                else {
                    availableTimes[currentTime] = String(hours) + ":30"
                    availableTimes[currentTime] = availableTimes[currentTime] + " am"
                }
            }
            currentTime = currentTime + 1
        }
        
        var i = 0
        while i < dataArray.count {
            var j = 0
            while j < availableTimes.count {
                if (availableTimes[j] == dataArray[i].title) {
                    dataArray[i].isOpen = true
                }
                j = j + 1
            }
            i = i + 1
        }
        items = dataArray.map { ViewModelItem(item: $0) }
    }
}



extension ViewModelTwo: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item = items[indexPath.row]
            
            // select/deselect the cell
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewModelTwo: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
}
