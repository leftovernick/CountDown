//
//  ViewCountdownViewController.swift
//  CountDown
//
//  Created by Nick Gray on 8/15/20.
//

import UIKit
import CoreData

class ViewCountdownViewController: UIViewController {
    
    var mainViewController: CountdownViewController?
    var datelb = UILabel()
    var dayslb = UILabel()
    var hourslb = UILabel()
    var minuteslb = UILabel()
    var secondslb = UILabel()
    var image = UIImageView()
    
    var event = Event()
    var timer: Timer?
    
    func setupDatelb() {
        datelb = UILabel(frame: CGRect(x: 0, y: view.frame.height / 8, width: view.frame.width, height: 21))
        view.addSubview(datelb)

        datelb.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        datelb.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        datelb.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        datelb.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true

        
        datelb.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        datelb.textColor = .label
        datelb.textAlignment = .center
        datelb.text = event.date?.formattedDateString(format: "EEEE, MMM d, yyyy")
        
    }
    
    func setupTimerlb() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: datelb.bottomAnchor, constant: 10).isActive = true
        
        let subStackView = UIStackView()
        subStackView.axis = .horizontal
        subStackView.spacing = 16
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subStackView)
        subStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        subStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        
      
        //Days
        dayslb = UILabel(frame: CGRect(x: 20 , y: datelb.frame.maxY + 4, width: 65, height: 50))
        dayslb.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dayslb)
        dayslb.widthAnchor.constraint(equalToConstant: 65).isActive = true
        dayslb.heightAnchor.constraint(equalToConstant: 50).isActive = true
   
        dayslb.font = UIFont.systemFont(ofSize: 40, weight: .light)
        dayslb.textColor = .label
        dayslb.textAlignment = .center
        
        
        let dtitle = UILabel(frame: CGRect(x: dayslb.frame.minX, y: dayslb.frame.maxY, width: 65, height: 50))
        subStackView.addArrangedSubview(dtitle)
        dtitle.text = "Days"
        
        dtitle.topAnchor.constraint(equalTo: dayslb.bottomAnchor, constant: -10).isActive = true
        dtitle.widthAnchor.constraint(equalToConstant: 65).isActive = true
        dtitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dtitle.font = UIFont.systemFont(ofSize: 16, weight: .light)
        dtitle.textColor = .label
        dtitle.textAlignment = .center
        
        
        //Hours
        hourslb = UILabel(frame: CGRect(x: dayslb.frame.maxX, y: datelb.frame.maxY + 4, width: 65, height: 50))
        hourslb.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(hourslb)
        hourslb.widthAnchor.constraint(equalToConstant: 65).isActive = true
        hourslb.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        hourslb.font = UIFont.systemFont(ofSize: 40, weight: .light)
        hourslb.textColor = .label
        hourslb.textAlignment = .center
        
        let htitle = UILabel(frame: CGRect(x: hourslb.frame.minX, y: hourslb.frame.maxY, width: 65, height: 50))
        subStackView.addArrangedSubview(htitle)
        htitle.text = "Hours"
        
        htitle.topAnchor.constraint(equalTo: hourslb.bottomAnchor, constant: -10).isActive = true
        htitle.widthAnchor.constraint(equalToConstant: 65).isActive = true
        htitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        htitle.font = UIFont.systemFont(ofSize: 16, weight: .light)
        htitle.textColor = .label
        htitle.textAlignment = .center
        
        
        //Minutes
        minuteslb = UILabel(frame: CGRect(x: view.frame.width / 1.5 , y: datelb.frame.maxY + 4, width: 65, height: 50))
        minuteslb.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(minuteslb)
        minuteslb.widthAnchor.constraint(equalToConstant: 65).isActive = true
        minuteslb.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        minuteslb.font = UIFont.systemFont(ofSize: 40, weight: .light)
        minuteslb.textColor = .label
        minuteslb.textAlignment = .center
        
        let mtitle = UILabel(frame: CGRect(x: minuteslb.frame.minX, y: minuteslb.frame.maxY, width: 65, height: 50))
        subStackView.addArrangedSubview(mtitle)
        mtitle.text = "Minutes"
        
        mtitle.topAnchor.constraint(equalTo: minuteslb.bottomAnchor, constant: -10).isActive = true
        mtitle.widthAnchor.constraint(equalToConstant: 65).isActive = true
        mtitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mtitle.font = UIFont.systemFont(ofSize: 16, weight: .light)
        mtitle.textColor = .label
        mtitle.textAlignment = .center
        
        
        //Seconds
        secondslb = UILabel(frame: CGRect(x: view.frame.width / 2 , y: datelb.frame.maxY + 4, width: 65, height: 50))
        secondslb.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(secondslb)
        secondslb.widthAnchor.constraint(equalToConstant: 65).isActive = true
        secondslb.heightAnchor.constraint(equalToConstant: 50).isActive = true
  
        secondslb.font = UIFont.systemFont(ofSize: 40, weight: .light)
        secondslb.textColor = .label
        secondslb.textAlignment = .center
        
        
        let stitle = UILabel(frame: CGRect(x: secondslb.frame.minX, y: secondslb.frame.maxY, width: 65, height: 50))
        subStackView.addArrangedSubview(stitle)
        stitle.text = "Seconds"
        
        stitle.topAnchor.constraint(equalTo: secondslb.bottomAnchor, constant: -10).isActive = true
        stitle.widthAnchor.constraint(equalToConstant: 65).isActive = true
        stitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stitle.font = UIFont.systemFont(ofSize: 16, weight: .light)
        stitle.textColor = .label
        stitle.textAlignment = .center
    

    }
    
    func setupImage() {
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = event.title
        
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        }

        let image = UIImage(data: event.image!)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        view.backgroundColor = UIColor(patternImage: image!)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            //still running when leaving view?
            self.updateCounter()
        }
        
        setupDatelb()
        setupTimerlb()
        
        updateCounter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.label
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        
    }
    

    func updateCounter() {
        
        var mutableDate = event.date
        var dateComponent = DateComponents()
        dateComponent.day = mutableDate?.days(from: Date())
        dateComponent.hour = mutableDate?.hours(from: Date())
        dateComponent.minute = mutableDate?.minutes(from: Date())
        dateComponent.second = mutableDate?.seconds(from: Date())
        
        dayslb.text = "\(mutableDate!.days(from: Date()))"
        mutableDate = Calendar.current.date(byAdding: .day, value: -((mutableDate?.days(from: Date()))!), to: mutableDate!)
        hourslb.text = "\(mutableDate!.hours(from: Date()))"
        mutableDate = Calendar.current.date(byAdding: .hour, value: -((mutableDate?.hours(from: Date()))!), to: mutableDate!)
        minuteslb.text = "\(mutableDate!.minutes(from: Date()))"
        mutableDate = Calendar.current.date(byAdding: .minute, value: -((mutableDate?.minutes(from: Date()))!), to: mutableDate!)
        secondslb.text = "\(mutableDate!.seconds(from: Date()))"
        
        
    }
}

 
