//
//  SwipeDismissKeyBoardViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class SwipeDismissKeyBoardViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        self.textView.becomeFirstResponder()
        
        let swipeGesture = UISwipeGestureRecognizer()
        
        swipeGesture.direction = UISwipeGestureRecognizerDirection.down
        
        swipeGesture.rx.event.subscribe(onNext:{ [weak self] _ in
        

              self?.view.endEditing(true)
            
        }).addDisposableTo(disposeBag)
        
        self.view.addGestureRecognizer(swipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
