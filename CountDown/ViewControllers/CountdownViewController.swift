//
//  CountdownViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/7/20.
//

import UIKit



struct DataId {
    var month = ""
    var count = 0
}

class CountdownViewController: UIViewController{
    
    let collectionViewHeaderReuseIdentifier = "HeaderClass"

    
    var sortedData : [[Any]] = [
        [DataId(month: "This Month", count: 0)],
        [DataId(month: "January", count: 0)],
        [DataId(month: "February", count: 0)],
        [DataId(month: "March", count: 0)],
        [DataId(month: "April", count: 0)],
        [DataId(month: "May", count: 0)],
        [DataId(month: "June", count: 0)],
        [DataId(month: "July", count: 0)],
        [DataId(month: "August", count: 0)],
        [DataId(month: "September", count: 0)],
        [DataId(month: "November", count: 0)],
        [DataId(month: "December", count: 0)],
        [DataId(month: "This Year", count: 0)],
        [DataId(month: "More", count: 0)]
    ]

    var currentMonthData : [Event] = []
    var januaryData: [Event] = []
    var februaryData: [Event] = []
    var marchData: [Event] = []
    var aprilData: [Event] = []
    var mayData: [Event] = []
    var juneData: [Event] = []
    var julyData: [Event] = []
    var augustData: [Event] = []
    var septemberData: [Event] = []
    var octoberData: [Event] = []
    var novemberData: [Event] = []
    var decemberData: [Event] = []
    var futureMonthData : [Event] = []
    
    let data = [
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: Date()),
        Event(title: "Gear", image: #imageLiteral(resourceName: "settings"), date: Date()),
        Event(title: "Default", image: #imageLiteral(resourceName: "CountdownDefault"), date: Date()),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: Date()),
        Event(title: "Gear", image: #imageLiteral(resourceName: "settings"), date: Date()),
        Event(title: "Default", image: #imageLiteral(resourceName: "CountdownDefault"), date: Date()),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: Date()),
        Event(title: "Gear", image: #imageLiteral(resourceName: "settings"), date: Date()),
        Event(title: "Default", image: #imageLiteral(resourceName: "CountdownDefault"), date: Date()),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: Date()),
        Event(title: "Gear", image: #imageLiteral(resourceName: "settings"), date: Date()),
        Event(title: "Default", image: #imageLiteral(resourceName: "CountdownDefault"), date: Date()),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: Date()),
        Event(title: "Gear", image: #imageLiteral(resourceName: "settings"), date: Date()),
        Event(title: "Default", image: #imageLiteral(resourceName: "CountdownDefault"), date: Date()),
    ]
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        
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
        let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(add))
        navigationItem.rightBarButtonItem = addBtn
        let settingsBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: nil, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBtn
        
        
        
    }
    
    func populateData() {
        let today = Date()
        let thisMonth = today.get(.month)
        for event in data {
            let date = event.date!.get(.day, .month, .year)
            
            //change from days to months
            if daysBetween(start: today, end: event.date!) > 90 {
               // sortedData.append(14, event)
            } else if let month = date.month {
                switch month {
                case thisMonth:
                    currentMonthData.append(event)
                case 1:
                    januaryData.append(event)
                case 2:
                    februaryData.append(event)
                case 3:
                    marchData.append(event)
                case 4:
                    aprilData.append(event)
                case 5:
                    mayData.append(event)
                case 6:
                    juneData.append(event)
                case 7:
                    julyData.append(event)
                case 8:
                    augustData.append(event)
                case 9:
                    septemberData.append(event)
                case 10:
                    octoberData.append(event)
                case 11:
                    novemberData.append(event)
                case 12:
                    decemberData.append(event)
                default:
                    futureMonthData.append(event)
                
                }
            }
        }
        
        
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    
    @objc func add() { }
    
    @objc func settings() { }
}

extension CountdownViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.3, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentMonthData.count
        case 1:
            return futureMonthData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCell
        cell.data = self.data[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            func setSection(dataId: DataId) -> DataId{
                var mutatedId = dataId
                while dataId.count == 0 && indexer < sortedData.count-1{
                    indexer += 1
                    mutatedId = sortedData[indexer][0] as! DataId

                }
                return mutatedId
            }

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseIdentifier, for: indexPath) as! customHeader
            
            var indexer = 0
            var nextSection = sortedData[indexer][0] as! DataId
            nextSection = setSection(dataId: nextSection)
            

            switch  indexPath {
            
            
            
            case[0,0]:
                print("index path is \(indexPath)")
                
                headerView.monthLabel.text = nextSection.month
                nextSection = setSection(dataId: nextSection)
                
          
            

            
            case[1,0]:
                headerView.monthLabel.text = nextSection.month
                nextSection = setSection(dataId: nextSection)


            case[2,0]:
                headerView.monthLabel.text = nextSection.month
                nextSection = setSection(dataId: nextSection)


            default:
                print("default path is \(indexPath)")

            
            //default:
                headerView.monthLabel.text = "Future Months"
            }
            
            
            
            return headerView

        default:

            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/15)
    }
    
    
}

class EventCell: UICollectionViewCell {
    
    var data: Event? {
        didSet {
        
            guard let data = data else {return}
            bg.image = data.image
            txt.text = data.title
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

