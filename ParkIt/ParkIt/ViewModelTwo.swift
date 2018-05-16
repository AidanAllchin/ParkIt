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
    
    override init() {
        self.spot = ParkingSpot()
        items = dataArray.map { ViewModelItem(item: $0) }
        super.init()
        getDataArray(spot: spot)
        items = dataArray.map { ViewModelItem(item: $0) }
    }
    
    init(spot: ParkingSpot) {
        self.spot = ParkingSpot()
        super.init()
        getDataArray(spot: spot)
        items = dataArray.map { ViewModelItem(item: $0) }
    }
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    func getDataArray(spot: ParkingSpot) {
        let avaliableTimes: [String] = spot.timesAvailable
        var dataArray = [Model(title: "12:00 am", isOpen: false), Model(title: "12:30 am", isOpen: false), Model(title: "1:00 am", isOpen: false), Model(title: "1:30 am", isOpen: false), Model(title: "2:00 am", isOpen: false), Model(title: "2:30 am", isOpen: false), Model(title: "3:00 am", isOpen: false), Model(title: "3:30 am", isOpen: false), Model(title: "4:00 am", isOpen: false), Model(title: "4:30 am", isOpen: false), Model(title: "5:00 am", isOpen: false), Model(title: "5:30 am", isOpen: false), Model(title: "6:00 am", isOpen: false), Model(title: "6:30 am", isOpen: false), Model(title: "7:00 am", isOpen: false), Model(title: "7:30 am", isOpen: false), Model(title: "8:00 am", isOpen: false), Model(title: "8:30 am", isOpen: false), Model(title: "9:00 am", isOpen: false), Model(title: "9:30 am", isOpen: false), Model(title: "10:00 am", isOpen: false), Model(title: "10:30 am", isOpen: false), Model(title: "11:00 am", isOpen: false), Model(title: "11:30 am", isOpen: false), Model(title: "12:00 pm", isOpen: false), Model(title: "12:30 pm", isOpen: false), Model(title: "1:00 pm", isOpen: false), Model(title: "1:30 pm", isOpen: false), Model(title: "2:00 pm", isOpen: false), Model(title: "2:30 pm", isOpen: false), Model(title: "3:00 pm", isOpen: false), Model(title: "3:30 pm", isOpen: false), Model(title: "4:00 pm", isOpen: false), Model(title: "4:30 pm", isOpen: false), Model(title: "5:00 pm", isOpen: false), Model(title: "5:30 pm", isOpen: false), Model(title: "6:00 pm", isOpen: false), Model(title: "6:30 pm", isOpen: false), Model(title: "7:00 pm", isOpen: false), Model(title: "7:30 pm", isOpen: false), Model(title: "8:00 pm", isOpen: false), Model(title: "8:30 pm", isOpen: false), Model(title: "9:00 pm", isOpen: false), Model(title: "9:30 pm", isOpen: false), Model(title: "10:00 pm", isOpen: false), Model(title: "10:30 pm", isOpen: false), Model(title: "11:00 pm", isOpen: false), Model(title: "11:30 pm", isOpen: false)]
        
        var i = 0
        while i < dataArray.count {
            for time in avaliableTimes {
                //TODO: Set times back to 12-hour time before comparison
                if (time == dataArray[i].title){
                    dataArray[i].isOpen = true
                }
            }
             i = i + 1
        }
            items = dataArray.map { ViewModelItem(item: $0) }
    }

    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
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
