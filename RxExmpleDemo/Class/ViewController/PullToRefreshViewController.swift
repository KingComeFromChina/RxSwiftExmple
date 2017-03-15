//
//  PullToRefreshViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/15.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PullToRefreshViewController: UIViewController {

    let cellID = "cell"
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        let items = Variable(["我","是","一","个","iOS","开","发","工","程","师"])
        
        let items2 = ["我","是","一","个","iOS","中","高","级","开","发","工","程","师"]
        
        items.asObservable().bindTo(tableView.rx.items(cellIdentifier: cellID, cellType: UITableViewCell.self)) { (row, element , cell) in
        
            cell.textLabel?.text = element
        }.disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {_ in
        
            items.value = items2
            
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.rx.itemDeleted.subscribe(onNext:{ indexPath in
        
            items.value.remove(at: indexPath.row)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemMoved.subscribe(onNext:{ fromIndexPath, toIndexPath in
        
            let element = items.value.remove(at: fromIndexPath.row)
            items.value.insert(element, at: toIndexPath.row)
        }).disposed(by: disposeBag)
        
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
