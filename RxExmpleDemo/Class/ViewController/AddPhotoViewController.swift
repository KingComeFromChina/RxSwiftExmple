//
//  AddPhotoViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddPhotoViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        
        
        
        barButtonItem.rx.tap.flatMapLatest({ [weak self] _ in
        
            return UIImagePickerController.rx.createWithParent(self) { picker in
            
                picker.sourceType    = .photoLibrary
                picker.allowsEditing = false
                }.flatMap({
                
                    $0.rx.didFinishPickingMediaWithInfo
                }).take(1)
        }).map({ info in
        
            return info[UIImagePickerControllerOriginalImage] as? UIImage
        }).bindTo(imageView.rx.image)
        .disposed(by: disposeBag)
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
