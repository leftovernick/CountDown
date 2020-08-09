//
//  CountdownViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/7/20.
//

import UIKit


struct Event {
    var title: String
    var image: UIImage
    var date: String
}
class CountdownViewController: UIViewController{
    
    let data = [
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "testImage"), date: "2020-08-08T22:18:30+0000"),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "CountdownDefaultWhite"), date: "2020-08-08T22:18:30+0000"),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "CountdownDefault"), date: "2020-08-08T22:18:30+0000"),
        Event(title: "Spelunky 2", image: #imageLiteral(resourceName: "settings"), date: "2020-08-08T22:18:30+0000")
    ]
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
        return cv
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        
        navigationController?.title = "Countdown"
        let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(add))
        navigationItem.rightBarButtonItem = addBtn
        let settingsBtn = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: nil, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBtn
        
        
        
    }
    

    
     @objc func add() { }
    
    @objc func settings() { }
}

extension CountdownViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.3, height: collectionView.frame.width/3.3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCell
        cell.data = self.data[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
        //lb.center = CGPoint(x: 0, y: 0)
        lb.textAlignment = .center



        lb.text = "TEST"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
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
