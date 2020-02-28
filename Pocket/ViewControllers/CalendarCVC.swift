import UIKit


class CalendarCVC: UICollectionView, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UITextFieldDelegate {
    
    var initialLoad = true
    
    var cellWidth = CGFloat(50)
    let cellReuseIdentifier = "cellId"
    
    let currentDay = Date.formatDateAndTimezoneString(date: Date(), dateFormat: "dd", timeZone: .LocalZone)
    var currentSelection: IndexPath?
    
    
    // List Data
    var entryCategory: [String] = []
    var entryAmount: [CGFloat] = []
    
    
    
    func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        
        self.backgroundColor =  UIColor.white
        self.register(CalendarCVCCalendarCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        cellWidth = self.frame.width/7
        
        
        print ("Calendar Collection View Loaded")
    }
    
    
    
    func viewDidAppear(_ animated: Bool) {
        if initialLoad == true {
//            print (currentDay)
            self.collectionView(self, didSelectItemAt: IndexPath(item: Int(currentDay)!-1, section: 0))
            self.selectItem(at: IndexPath(row: Int(currentDay)!-1, section: 0), animated: true, scrollPosition: .top)
            currentSelection = IndexPath(row: Int(currentDay)!-1, section: 0)
            initialLoad = false
        }
        else {
            // Must reselect when coming back from view, otherwise after returning from another clicking another cell will not clear the last selected cell
            self.collectionView(self, didSelectItemAt: currentSelection!)
            self.selectItem(at: currentSelection, animated: true, scrollPosition: .top)
        }
    }
    
    
    /// number of cells in section
    func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Date.getNumberOfDaysInMonth(date: Date())
    }
    
    
    /// what each cell is going to display
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarCVCCalendarCell
//        cell.backgroundColor = UIColor.purple
        cell.layer.borderWidth = 0.1
        cell.label.text = String(indexPath.row+1)
        
        // Needed so we when cells are reused we still highlight the correct cell
        if cell.isSelected && cell.backgroundColor != UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue) {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        } else if cell.backgroundColor != UIColor.white{
            cell.backgroundColor = .white
        }
        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: self.frame.width/7, height: self.frame.width/7);
        } else {
            return CGSize(width: self.frame.width, height: 30)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCalendarCell {
            cell.backgroundColor = UIColor(rgb: 0xF4AA00)
            currentSelection = indexPath
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCalendarCell {
            cell.backgroundColor = UIColor.white
        }
    }
    
}
