//
//  MainViewUIService.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class MainViewUIService: NSObject, UITableViewDelegate,UITableViewDataSource {

    let cellID = "cell"
    
    var mainVC        : MainViewController!
    
    var mainUIViewModel : MainViewModelService!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainUIViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        var model = MainModel()
        
        if self.mainUIViewModel.dataSource.count > 0 {
            
            model = self.mainUIViewModel.dataSource[indexPath.row]
        }
        
        cell.textLabel?.text = model.title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let tapVC = TapViewController()
            
            self.mainVC.navigationController?.pushViewController(tapVC, animated: true)
        } else if indexPath.row == 1 {
        
            let getDateAndTimeVC = GetDateAndTimeViewController()
            
            self.mainVC.navigationController?.pushViewController(getDateAndTimeVC, animated: true)
            
        } else if indexPath.row == 2 {
        
            let swipeDismissKeyBoardVC = SwipeDismissKeyBoardViewController()
            
            self.mainVC.navigationController?.pushViewController(swipeDismissKeyBoardVC, animated: true)
            
        }else if indexPath.row == 3 {
        
            let addPhotoVC = AddPhotoViewController()
            
            self.mainVC.navigationController?.pushViewController(addPhotoVC, animated: true)
            
        }else if indexPath.row == 4 {
        
            let pullfreshVC = PullToRefreshViewController()
            
            self.mainVC.navigationController?.pushViewController(pullfreshVC, animated: true)
            
        }else if indexPath.row == 5 {
        
            let testTableViewVC = TableTestViewController()
            
            self.mainVC.navigationController?.pushViewController(testTableViewVC, animated: true)
            
        }else if indexPath.row == 6 {
        
            let LocalDataVC = LocalDataViewController()
            
            self.mainVC.navigationController?.pushViewController(LocalDataVC, animated: true)
            
        }else if indexPath.row == 7 {
        
            let addPostVC = AddPostViewController()
            
            self.mainVC.navigationController?.pushViewController(addPostVC, animated: true)
            
        }
    }
    
}
