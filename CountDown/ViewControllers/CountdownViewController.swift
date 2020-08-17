//
//  CountdownViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/7/20.
//

import UIKit
import CoreData



struct DataSections {
    var month = ""
    var count = 0
    var events : [NSManagedObject] = []
}

class CountdownViewController: UIViewController{
    
    let collectionViewHeaderReuseIdentifier = "HeaderClass"
    var selectedEvent = Event()
    
    var sortedData : [DataSections] = []
    var data : [NSManagedObject] = []
    
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFromCore()
        populateData()
        collectionView.reloadData()
          
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.backgroundColor = .secondarySystemBackground
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.register(customHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderReuseIdentifier)

        
        navigationController?.title = "Countdown"
        let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = addBtn
        let settingsBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBtn
        
        
        
    }
    
    func populateData() {
        
        sortedData.removeAll()
        sortedData = [
            DataSections(month: "This Month"),
            DataSections(month: "January"),
            DataSections(month: "February"),
            DataSections(month: "March"),
            DataSections(month: "April"),
            DataSections(month: "May"),
            DataSections(month: "June"),
            DataSections(month: "July"),
            DataSections(month: "August"),
            DataSections(month: "September"),
            DataSections(month: "October"),
            DataSections(month: "November"),
            DataSections(month: "December"),
            DataSections(month: "This Year"),
            DataSections(month: "More")
        ]
        
        
        let today = Date()
        let thisMonth = today.get(.month)
        for event in data {
            let date = event.value(forKeyPath: "date") as! Date
            let components = date.get(.day, .month, .year)
            
            //change from days to months
            if monthsBetween(start: today, end: date) > 3 {
                if thisYear(year: components.year!) {
                    sortedData[13].events.append(event)
                    sortedData[13].count += 1
                } else {
                    sortedData[14].events.append(event)
                    sortedData[14].count += 1
                }

            } else if let month = components.month {
                switch month {
                case thisMonth:
                    sortedData[0].events.append(event)
                    sortedData[0].count += 1
                default:
                    sortedData[month].events.append(event)
                    sortedData[month].count += 1

                }
            }
        }
        data.removeAll()
        print("After populating data array size is \(data.count)")
    }
    
    func loadFromCore() {
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        do {
            data = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    func saveEvent(title: String, image: UIImage, date: Date) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Event",
                                       in: managedContext)!
        
        let event = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        let imgData = image.pngData()

        
        event.setValue(title, forKeyPath: "title")
        event.setValue(imgData, forKeyPath: "image")
        event.setValue(date, forKeyPath: "date")
     
        do {
            try managedContext.save()
            data.append(event)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }

        populateData()
        collectionView.reloadData()

    }
    
    func monthsBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: start, to: end).month!
    }
    
    func thisYear(year: Int) -> Bool {
        if year == Calendar.current.component(.year, from: Date()) {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        
        if segue.identifier == "newCountdownSegue" {
           
            let newVC = segue.destination as! NewCountdownViewController
            newVC.mainViewController = self
        } else if segue.identifier == "showEventSegue" {
            
            let viewVC = segue.destination as! ViewCountdownViewController
            viewVC.mainViewController = self
            viewVC.event = selectedEvent


        }
    }

    
    @objc func add() {
        self.performSegue(withIdentifier: "newCountdownSegue", sender: nil)
    }
    
    @objc func settings() { }
}

extension CountdownViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.3, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        for index in 0...numberOfSections(in: collectionView) {
            if section == index {
                return sortedData[index].count
            }
        }
        
        return sortedData[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCell

        cell.data = self.sortedData[indexPath.section].events[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       var numSections = 0
        

        for section in sortedData {
            if section.count == 0 {
                sortedData.remove(at: numSections)
            } else {
                numSections += 1
            }
        }

        return numSections
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            func setSection(dataId: DataSections) -> DataSections{
                var mutatedId = dataId
                while dataId.count == 0 && indexer < sortedData.count-1{
                    indexer += 1
                    mutatedId = sortedData[indexer]

                }
                return mutatedId
            }

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseIdentifier, for: indexPath) as! customHeader
            
            var indexer = 0
            var nextSection = sortedData[indexer]
            nextSection = setSection(dataId: nextSection)
            

            switch  indexPath {

            case[0,0]:
                headerView.monthLabel.text = sortedData[0].month
                nextSection = setSection(dataId: nextSection)

            case[1,0]:
                headerView.monthLabel.text = sortedData[1].month
                nextSection = setSection(dataId: nextSection)


            case[2,0]:
                headerView.monthLabel.text = sortedData[2].month
                nextSection = setSection(dataId: nextSection)
                
            case[3,0]:
                headerView.monthLabel.text = sortedData[3].month
                nextSection = setSection(dataId: nextSection)
                
            case[4,0]:
                headerView.monthLabel.text = sortedData[4].month
                nextSection = setSection(dataId: nextSection)
                    
            case[5,0]:
                headerView.monthLabel.text = sortedData[5].month
                nextSection = setSection(dataId: nextSection)

            case[6,0]:
                headerView.monthLabel.text = sortedData[6].month
                nextSection = setSection(dataId: nextSection)


            case[7,0]:
                headerView.monthLabel.text = sortedData[7].month
                nextSection = setSection(dataId: nextSection)
                
            case[8,0]:
                headerView.monthLabel.text = sortedData[8].month
                nextSection = setSection(dataId: nextSection)
                
            case[9,0]:
                headerView.monthLabel.text = sortedData[9].month
                nextSection = setSection(dataId: nextSection)
                
            case[10,0]:
                headerView.monthLabel.text = sortedData[10].month
                nextSection = setSection(dataId: nextSection)

            case[11,0]:
                headerView.monthLabel.text = sortedData[11].month
                nextSection = setSection(dataId: nextSection)


            case[12,0]:
                headerView.monthLabel.text = sortedData[12].month
                nextSection = setSection(dataId: nextSection)
                
            case[13,0]:
                headerView.monthLabel.text = sortedData[13].month
                nextSection = setSection(dataId: nextSection)

            default:
                print("Month value not found")
                headerView.monthLabel.text = "Other"
            }
            
            return headerView

        default:

            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEvent = sortedData[indexPath.section].events[indexPath.row] as! Event
        
        self.performSegue(withIdentifier: "showEventSegue", sender: nil)

    }
}

class EventCell: UICollectionViewCell {
    
    var data: NSManagedObject? {
        didSet {
        
            guard let data = data else {return}
            bg.image = UIImage(data: (data.value(forKeyPath: "image") as? Data)!)
            let date = data.value(forKeyPath: "date") as? Date
            var timeLeft = date?.months(from: Date())
            if timeLeft! <= 3 {
                timeLeft = date?.days(from: Date())
                if timeLeft! == 0 {
                    timeLeft = date?.hours(from: Date())
                    
                    txt.text = "\(timeLeft ?? 0) Hours"
                }
                txt.text = "\(timeLeft ?? 0) Days"
            } else {
                txt.text = "\(timeLeft ?? 0) Months"
            }
        }
    }
    
    fileprivate let bg : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "CountdownDefault")
        iv.backgroundColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    fileprivate let txt : UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        lb.font = UIFont.preferredFont(forTextStyle: .footnote)
        lb.textColor = .label
        lb.textAlignment = .center
        lb.text = "TEST"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        contentView.addSubview(txt)
        txt.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        txt.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        txt.center = CGPoint(x: frame.width/2, y: frame.height)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class customHeader: UICollectionReusableView {

    fileprivate let monthLabel : UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        lb.font = UIFont.preferredFont(forTextStyle: .headline)
        lb.textColor = .label
        lb.textAlignment = .left
        lb.text = "This Month"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(monthLabel)
        monthLabel.frame = CGRect(x: 4, y: 0, width: self.bounds.width, height: 100)
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }

}

