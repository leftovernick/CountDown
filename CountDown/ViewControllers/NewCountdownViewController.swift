//
//  NewCountdownViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/10/20.
//

import UIKit
import CoreData

class NewCountdownViewController: UIViewController {
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var searchTitle = ""
    

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        safeArea = view.layoutMarginsGuide
        setupTableView()

    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.estimatedRowHeight = 50
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(DateCell.self, forCellReuseIdentifier: "dateCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(LeftoverCell.self, forCellReuseIdentifier: "leftoverCell")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "New Countdown"
        let doneBtn = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = doneBtn
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = cancelBtn
        
    }
    
    func updateTitle(title: String) {
        searchTitle = title
    }

    
    @objc func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func add() {
        //Todo: write new Event to CoreData
        //      refresh collectionView
        _ = navigationController?.popViewController(animated: true)

    }

}

extension NewCountdownViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleCell
            cell.tfChangedAction = { [unowned self] in
                
                self.searchTitle = cell.tf.text!
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
        
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftoverCell", for: indexPath) as! LeftoverCell
        
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 2: return 150
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "addImageSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "addImageSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            let imageVC = segue.destination as! AddImageViewController
            imageVC.searchTitle = self.searchTitle
            
        }

    }
    
}

class DateCell: UITableViewCell {
    fileprivate let dp : UIDatePicker = {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: Date())
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }

        let udp = UIDatePicker()
        udp.date = tomorrow!.setTime(hour: 0, min: 0, sec: 0, timeZoneAbbrev: localTimeZoneAbbreviation)!
        udp.minimumDate = Date()
        udp.datePickerMode = .dateAndTime
        udp.translatesAutoresizingMaskIntoConstraints = false
        

        
        return udp
    }()
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        selectionStyle = .none
        textLabel?.text = "Date & Time"
        
        contentView.addSubview(dp)
        dp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        dp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: frame.width / 2.5).isActive = true
        dp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        dp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true


    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TitleCell: UITableViewCell {
    fileprivate let tf : UITextField = {
        let txtf = UITextField()
        txtf.placeholder = "Title"
        txtf.translatesAutoresizingMaskIntoConstraints = false
        txtf.autocapitalizationType = .words
        txtf.clearButtonMode = .whileEditing


        return txtf
    }()
    
    var tfChangedAction : (() -> ())?



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .secondarySystemBackground

        
        contentView.addSubview(tf)
        tf.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        tf.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        tf.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        tf.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTitle() -> String {
        return tf.text ?? ""
    }
    
    @objc func textFieldDidChange() {
        tfChangedAction?()
    }
    

}


class ImageCell: UITableViewCell {
    
    fileprivate let iv : UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "testImage")
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFit
        imv.clipsToBounds = true
        

        return imv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        textLabel?.text = "Image"
        backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(iv)
        iv.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        iv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -4).isActive = true
        iv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: frame.width/3).isActive = true
        iv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class LeftoverCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
