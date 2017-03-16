//
//  NextViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/16.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

private extension Reactive where Base: UILabel{

    var location : AnyObserver<CLLocation>{
    
        return UIBindingObserver(UIElement: base){ label, location in
        
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
                debugPrint(location)
                
                if error != nil {
                    debugPrint("获取定位失败错误" + (error!.localizedDescription))
                    return
                }
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    
                    let pm = placemarks[0]
                    
                    let street = disPlayLocationInfo(placemark: pm)
                    
                    debugPrint(street)
                    
                    label.text = street
                    
                }else{
                    
                    debugPrint("模拟器获取不到位置")
                
                }
            })
        }.asObserver()
    }
    
}

func disPlayLocationInfo(placemark: CLPlacemark) -> String {
    
    let location = "\(placemark.thoroughfare ?? "") \(placemark.locality ?? "") \(placemark.administrativeArea ?? "") \(placemark.country ?? "")"
    
    return location
}

private extension Reactive where Base : UIView {

    var driveAuthorization: AnyObserver<Bool> {
    
        return UIBindingObserver(UIElement: base){ view, authorized in
        
            if authorized {
                
                view.isHidden = true
                
                view.superview?.sendSubview(toBack: view)
            }
        }.asObserver()
    }
    
}

public let WLWindowWidth = UIScreen.main.bounds.size.width

public let WLWindowHeight = UIScreen.main.bounds.size.height

public func RGB(r:CGFloat,_ g:CGFloat,_ b: CGFloat) -> UIColor{
    
    return UIColor (red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}


class NextViewController: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet var dateView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var timeStr : String!
    
    
    lazy var toolBar : UIToolbar = {
    
        var bar = UIToolbar()
        
        bar.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        
        bar.tintColor = UIColor.white
        
        bar.isTranslucent = false
        
        bar.clipsToBounds = true
        
        bar.items = [
            self.cameraButton,
            self.locationBtn,
            UIBarButtonItem(customView: self.locationLabel),
            UIBarButtonItem(customView: self.imageView)
        ]
        
    return bar
    }()
    
    let cameraButton : UIBarButtonItem = {
    
        let btn = UIBarButtonItem()
        
        btn.image = UIImage(named: "camera")!.withRenderingMode(.alwaysOriginal)
        
        btn.tintColor = UIColor.init(red: 239/255, green: 249/255, blue: 246/255, alpha: 1.0)
        
        return btn
    }()
    
    let locationBtn : UIBarButtonItem = {
    
        let btn = UIBarButtonItem()
        
        btn.image = UIImage(named: "location")!.withRenderingMode(.alwaysOriginal)
        
        return btn
        
    }()
    
    let imageView : UIImageView = {
    
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
       
        return imageView
        
    }()
    
    
    let locationLabel : UILabel = {
    
        let location = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
        
        location.adjustsFontSizeToFitWidth = true
        
        location.textColor = UIColor.darkGray
        
        return location
    }()
    
    let geolocationService = GeolocationService.instance
    
    let noGeolocationView : UIView = {
    
        let view = UIView()
        
        return view
    }()
    
    weak var delegate: TableViewDelegate? = nil
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.dateView.frame = CGRect.init(x: 0, y: WLWindowHeight, width: WLWindowWidth, height: WLWindowHeight)
//        self.view.addSubview(self.dateView)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.inputAccessoryView = toolBar
        
        let rightBarButtonItem1 = UIBarButtonItem.init(title: "发送", style: .done, target: self, action: nil)
        
        let rightBarButtonItem2 = UIBarButtonItem.init(title: "定时", style: .done, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1,rightBarButtonItem2]
        
        datePicker.datePickerMode = .dateAndTime;
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        
        dateFormatter.timeStyle = .medium
        
        
        let currentDateTime = Date()
        
        let formatter       = DateFormatter()
        
        formatter.timeStyle = .medium
        
        formatter.dateStyle = .long
        
        timeStr = formatter.string(from: currentDateTime)
        
        
        
        self.textView.becomeFirstResponder()
        
        let swipeGesture = UISwipeGestureRecognizer()
        
        swipeGesture.direction = UISwipeGestureRecognizerDirection.down
        
        swipeGesture.rx.event.subscribe(onNext:{ [weak self] _ in
            
            
            self?.view.endEditing(true)
            
        }).addDisposableTo(disposeBag)
        
        self.view.addGestureRecognizer(swipeGesture)
        
        self.dateView.isUserInteractionEnabled = true
        
        /////添加tapGuestureRecognizer手势
        let tapGR = UITapGestureRecognizer()
        
        tapGR.rx.event.subscribe(onNext: { [weak self] _ in
        
            self?.dateView.removeFromSuperview()
            
        }).addDisposableTo(disposeBag)
        
        self.dateView.addGestureRecognizer(tapGR)
        
        
        
        cameraButton.rx.tap.flatMapLatest({[weak self] _ in
        
            return UIImagePickerController.rx.createWithParent(self) { picker in
            
                picker.sourceType = .photoLibrary
                
                picker.allowsEditing = true
                
                }.flatMap({ $0.rx.didFinishPickingMediaWithInfo })
            .take(1)
        }).map({ info in
        
            return info[UIImagePickerControllerEditedImage] as? UIImage
        }).bindTo(imageView.rx.image)
          .disposed(by: disposeBag)
        
        
        
        geolocationService.authorized
            .drive(noGeolocationView.rx.driveAuthorization)
            .disposed(by: disposeBag)
        
        geolocationService.location
            .drive(locationLabel.rx.location)
            .disposed(by: disposeBag)
        
        locationBtn.rx.tap.bindNext {
            
            [weak self] in
            
            self?.geolocationService.updateLocation()
        }.disposed(by: disposeBag)
        
        
        if Platform.isSimulator {
            // Do one thing
            print("是模拟器")
            self.locationLabel.text = "郑州"
        }
        
        rightBarButtonItem2.rx.tap.bindNext {
            
            [weak self] in
            
            self?.textView.resignFirstResponder()
            
            self?.dateView.frame = CGRect.init(x: 0, y: 64, width: WLWindowWidth, height: WLWindowHeight)
            
            self?.view.addSubview((self?.dateView)!)
            
            let selectedDate = dateFormatter.string(from: (self?.datePicker.date)!)
            
            self?.timeLabel.text = selectedDate
            
            self?.timeStr = selectedDate
            
            }.addDisposableTo(disposeBag)
        
        datePicker.addTarget(self, action: #selector(NextViewController.dateChanged), for: .valueChanged)
        
        
        
        rightBarButtonItem1.rx.tap.bindNext {
            
            [weak self] in
            
          
            
            let item = Item(image: (self?.imageView.image!)!, date: (self?.timeStr!)!, content: (self?.textView.text!)!, location: (self?.locationLabel.text!)!)
            
            
            
            self?.delegate?.addItem(item: item)
            
            _ = self?.navigationController?.popViewController(animated: true)
            
        }.disposed(by: disposeBag)
        
      
        
    }

    

    struct Platform {
    
        static let isSimulator: Bool = {
        
            var isSim = false
        
            #if arch(i386) || arch(x86_64)
            
                isSim = true
        
            #endif
       
            return isSim
    }()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func dateChanged(){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        
        dateFormatter.timeStyle = .medium
    
        let selectedDate = dateFormatter.string(from: (self.datePicker.date))
        
        self.timeLabel.text = selectedDate
        
        self.timeStr = selectedDate
        
    }
  

}
