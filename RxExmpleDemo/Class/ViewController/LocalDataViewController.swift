//
//  LocalDataViewController.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/15.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LocalDataViewController: UIViewController {

    let content = "content"
    
    let Header  = "Header"
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,[String:String]>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: content)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Header)
        
        let dict = loadDict(fileName: "dict") as! [[String: String]]
        
        let items = Observable.just([
            
            SectionModel(model: "RECENT", items: [
                
                [
                    "name":"Mrs. Carolyn Tillman",
                    "avatar":"avatar13",
                    "mobile":"1-764-949-9148",
                    "email":"ardella.mueller@hotmail.com",
                    "notes":"Quod pickled vel post-ironic et. Sit consequatur consectetur quod. Et salvia small batch exercitationem."
                ],
                [
                    "name":"Geovanni Will",
                    "avatar":"avatar14",
                    "mobile":"905-253-0435", "email":"antonina@hotmail.com",
                    "notes":"Et gentrify enim art party dolorum sint sunt wes anderson. Et cray literally id totam."
                ],
                [
                    "name":"Edythe Stoltenberg",
                    "avatar":"avatar15",
                    "mobile":"696-408-8248",
                    "email":"viviane_lockman@gmail.com",
                    "notes":"Farm-to-table ea non nesciunt chambray quia. Bitters voluptatem paleo sed."
                ]]),
            
            SectionModel(model: "FRIENDS", items: dict)

            ])
        
        let dataSource = setUpDataSource()
        
        items.bindTo(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext:{ [weak self] indexPath in
        
            let detailVc = DetailViewController()
            
            let item = self!.dataSource.itemAtIndexPath(indexPath: indexPath as NSIndexPath)
            
            detailVc.name   = item["name"]!
            
            detailVc.mobile = item["mobile"]!
            
            detailVc.email  = item["email"]!
            
            detailVc.note   = item["notes"]!
            
            detailVc.avatar = item["avatar"]!
            
            
            
            self?.navigationController?.pushViewController(detailVc, animated: true)
            
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
        
    }
    
    func setUpDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String,[String : String]>> {
        
        dataSource.configureCell = {(_,tv,indexPath,element) in
        
            let cell = tv.dequeueReusableCell(withIdentifier: self.content)
            
            cell?.textLabel?.text = element["name"]
            
            let image = UIImage(named: element["avatar"]!)
            
            let imageSize = CGSize.init(width: 36, height: 36)
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            
            let imageRect = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            
            image?.draw(in: imageRect)
            
            cell?.imageView?.layer.cornerRadius = 18
            
            cell?.imageView?.layer.masksToBounds = true
            
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return cell!
        }
        
        return dataSource
    }
    
    func loadDict(fileName: String) -> [NSDictionary]? {
    
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
            
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                
                do {
                
                    let jsonResult: [NSDictionary] = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as! [NSDictionary]
                    
                    
                    return jsonResult
                } catch let error as NSError {
                
                    print(error.localizedDescription)
                }
                
            }catch let error as NSError {
            
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}

extension LocalDataViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Header)
        
        let greenColor = UIColor(red: 139/255, green: 87/255, blue: 42/255, alpha: 1.0)
        
        let attributedColor  = [NSForegroundColorAttributeName : greenColor]
        
        let attributedString = NSAttributedString.init(string: dataSource.sectionAtIndex(section: section).model, attributes:attributedColor)
        
        cell?.textLabel?.attributedText = attributedString
        
        return cell
    }
    
}

