//
//  TapViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public let disposeBag = DisposeBag()

class TapViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var tapBtn: UIButton!
   
    @IBOutlet weak var resetBtn: UIButton!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.numberLabel.text = "0"
        
        tapBtn.rx.tap.subscribe(onNext:{[weak self] in
        
            let number = Int((self?.numberLabel.text)!)
            
            self?.numberLabel.text = String(number! + 1)
        }).disposed(by: disposeBag)

        resetBtn.rx.tap.subscribe(onNext:{[weak self] in
        
            self?.numberLabel.text = "0"
        }).disposed(by: disposeBag)

        
        let longPressGesture = UILongPressGestureRecognizer()
        
        longPressGesture.rx.event.subscribe(onNext: { [weak self] _ in
        
            let number = Int((self?.numberLabel.text)!)
            
            self?.numberLabel.text = String(number! + 2)
            
        }).disposed(by: disposeBag)
        
       self.view.addGestureRecognizer(longPressGesture)
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
