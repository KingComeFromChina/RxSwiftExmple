//
//  MainViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var mainViewModel     : MainViewModelService!
    
    var mainViewUIService : MainViewUIService!
    
    let cellID = "cell"
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "RxSwiftExmple"

        self.startService()
        
        self.mainViewModel.creatData()
        
        self.mainTableView.reloadData()
        
        self.creatTableView()
    }
    
    // Start Service
    
    func startService(){
    
        self.mainViewModel                     = MainViewModelService()
        
        self.mainViewUIService                 = MainViewUIService()
        
        self.mainViewUIService.mainVC          = self
        
        self.mainViewUIService.mainUIViewModel = self.mainViewModel
        
    }

    func creatTableView(){
        
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    
        self.mainTableView.delegate   = self.mainViewUIService
        
        self.mainTableView.dataSource = self.mainViewUIService
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
}
