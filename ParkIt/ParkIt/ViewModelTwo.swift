//Wfrohllich


import Foundation
import UIKit

let dataArray2 = [Model(title: "12:00 am"), Model(title: "12:30 am"), Model(title: "1:00 am"), Model(title: "1:30 am"), Model(title: "2:00 am"), Model(title: "2:30 am"), Model(title: "3:00 am"), Model(title: "3:30 am"), Model(title: "4:00 am"), Model(title: "4:30 am"), Model(title: "5:00 am"), Model(title: "5:30 am"), Model(title: "6:00 am"), Model(title: "6:30 am"), Model(title: "7:00 am"), Model(title: "7:30 am"), Model(title: "8:00 am"), Model(title: "8:30 am"), Model(title: "9:00 am"), Model(title: "9:30 am"), Model(title: "10:00 am"), Model(title: "10:30 am"), Model(title: "11:00 am"), Model(title: "11:30 am"), Model(title: "12:00 pm")]

class ViewModelTwoItem {
    private var item: Model
    
    var isSelected = false
    
    var title: String {
        return item.title
    }
    
    init(item: Model) {
        self.item = item
    }
}

class ViewModelTwo: NSObject {
    var items = [ViewModelItem]()
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items = dataArray2.map { ViewModelItem(item: $0) }
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