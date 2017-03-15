//
//  DetailViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/15.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var name   : String = ""
    var avatar : String = ""
    var mobile : String = ""
    var email  : String = ""
    var note   : String = ""


    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var headView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = name
        
        mobileLabel.text = mobile
        
        emailLabel.text = email
        
        noteLabel.text = note
        
        headView.image = UIImage(named: avatar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
