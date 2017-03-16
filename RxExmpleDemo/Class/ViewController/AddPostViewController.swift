//
//  AddPostViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/16.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Item {
    
    let image    : UIImage
    
    let date     : String
    
    let content  : String
    
    let location : String
    
    init(image: UIImage, date: String,content: String,location: String) {
        
        self.image    = image
        
        self.date     = date
        
        self.content  = content
        
        self.location = location
    }
}

protocol TableViewDelegate : class {
    
    func addItem(item: Item)
}

class AddPostViewController: UIViewController, TableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let items = Variable(Array<Item>())
    
    let cell = "cell"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        rightBarButtonItem.rx.tap.subscribe(onNext: {[weak self] in
        
            let nextVC = NextViewController()
            
            nextVC.delegate = self
            
            self?.navigationController?.pushViewController(nextVC, animated: true)
            
        }).disposed(by: disposeBag)
        
        tableView.register(UINib (nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cell)
        
        tableView.rowHeight = 150
        
        items.asObservable().bindTo(tableView.rx.items(cellIdentifier: cell, cellType: TableViewCell.self)){ (row , element, cell) in
        
            cell.pic.image          = element.image
            
            cell.locationLabel.text = element.location
            
            cell.dateLabel.text     = element.date
            
            cell.contentLabel.text  = element.content
            
        }.addDisposableTo(disposeBag)
        
        
        
    }

    
    func addItem(item: Item){
    
        self.items.value.insert(item, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
