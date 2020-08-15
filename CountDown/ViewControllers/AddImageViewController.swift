//
//  AddImageViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/14/20.
//

import UIKit

class AddImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    var imagePicker: UIImagePickerController!
    var image = UIImage(imageLiteralResourceName: "CountdownDefault")
    let pasteboard = UIPasteboard.general

    
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
        tableView.register(ImagePreviewCell.self, forCellReuseIdentifier: "imagePreviewCell")
        tableView.register(SelectionCell.self, forCellReuseIdentifier: "selectionCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            image = img
            tableView.reloadData()

        }
    }

    
    
}

extension AddImageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagePreviewCell", for: indexPath) as! ImagePreviewCell
            cell.data = image
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
            cell.textLabel?.text = "Take Photo"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
            cell.textLabel?.text = "Choose Photo"
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
            cell.textLabel?.text = "Image Search"
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
            cell.textLabel?.text = "Paste Photo"
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
            cell.textLabel?.text = "Delete Photo"

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return 300
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera

            present(imagePicker, animated: true, completion: nil)
            
        case 2:
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary

            present(imagePicker, animated: true, completion: nil)
            
        case 4:
            if pasteboard.hasImages{
             
                image = pasteboard.image ?? image
             
            }
            tableView.reloadData()
            
        default:
            self.image = #imageLiteral(resourceName: "CountdownDefaultWhite")
            tableView.reloadData()

        }
    }
    
    
}

class ImagePreviewCell: UITableViewCell {
    
    var data: UIImage? {
        didSet {
        
            guard let data = data else {return}
            iv.image = data
        }
    }

    
    fileprivate let iv : UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFit
        imv.clipsToBounds = true
        

        return imv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(iv)
        iv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        iv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        iv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        iv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SelectionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .secondarySystemBackground

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
