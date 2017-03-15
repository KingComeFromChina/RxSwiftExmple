//
//  TableTestViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/15.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableTestViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cell = "cell"
    
    let header = "header"
    
    
    let items = Observable.just(
        
        [SectionModel(model:"B",items:[
            
            "Barbara Cole",
            "Barbara Cooper",
            "Barbara Diaz",
            "Barbara Edwards",
            "Barbara Garcia",
            "Barbara Gray",
            "Barbara Griffin",
            "Barbara Hill",
            "Barbara Howard",
            "Barbara Hughes"
            ]),
         
         SectionModel(model:"C",items:[
            "Carol Lopez",
            "Carol Lopez"
            ]),
         
         SectionModel(model:"E",items:[
            "Elizabeth Jenkins",
            "Elizabeth Kelly"
            ]),
         
         SectionModel(model:"H",items:[
            "Helen Anderson",
            "Helen Bailey",
            "Helen Cole",
            "Helen Cox"
            ]),
         
         SectionModel(model: "J", items: [
            "James Anderson",
            "James Barnes",
            "James Bell"
            ]),
         
         SectionModel(model: "K", items: [
            "Karen Green",
            "Karen Jenkins",
            "Karen Jones",
            "Karen Jordan"
            ]),
         
         SectionModel(model: "L", items: [
            "Linda Taylor",
            "Linda Taylor",
            "Linda Torres",
            "Linda West",
            "Lisa Brooks"
            ]),
         
         SectionModel(model: "M", items: [
            "Margaret Bell",
            "Margaret Coleman",
            "Margaret Cox",
            "Margaret Foster"
            ]),
         
         SectionModel(model: "R", items: [
            "Robert Clark",
            "Robert Coleman",
            "Robert Cook",
            "Robert Cook"
            ]),
         
         SectionModel(model: "S", items: [
            "Susan Fisher",
            "Susan Ford",
            "Susan Ford",
            "Susan Hernandez",
            "Susan Howard"
            ]),
         ])
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: header)
        
       
        
        let dataSource = setUpDataSource()
        
        
        items.bindTo(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        
        
        tableView.rx.setDelegate(self)
        
        
        
    }

    func setUpDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String,String>> {
        
        dataSource.configureCell = { (_, TestTableView,indexPatch, element) in
            
            let cell = TestTableView.dequeueReusableCell(withIdentifier: self.cell)
            
            cell?.textLabel?.text = element
            
            return cell!
        }
        
        dataSource.sectionForSectionIndexTitle = {(dataSource, title , index) -> Int in
        
            return index
        }
        
        dataSource.sectionIndexTitles = {ds -> [String]? in
        
            return ds.sectionModels.map({ $0.model})
        }

        return dataSource
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 20
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: header)
        
        cell!.textLabel?.text = dataSource.sectionAtIndex(section: section).model
        cell?.backgroundColor = UIColor.lightGray
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
