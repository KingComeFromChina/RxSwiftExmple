//
//  GetDateAndTimeViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GetDateAndTimeViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshBtn.rx.tap.map{ _ in
        
            let dateformatter = DateFormatter()
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .medium
            
            return dateformatter.string(from: Date())
            
        }.bindTo(timeLabel.rx.text)
        .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
