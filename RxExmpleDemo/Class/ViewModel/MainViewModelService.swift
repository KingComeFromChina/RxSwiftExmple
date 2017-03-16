//
//  MainViewModelService.swift
//  RxExmpleDemo
//
//  Created by 王垒 on 2017/3/14.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class MainViewModelService: NSObject {

    var dataSource = [MainModel]()
    
    
    func creatData(){
        
        let titleArray = ["Tap","GetDateAndTime","SwipeDismissKeyBoard","AddPhoto","PullToRefresh","TableTest","LocalDataViewController","AddPostVC"]
        
        let count = titleArray.count
        
        
        for i in 0..<count {
            
            let model = MainModel()
            
            model.title = titleArray[i]
            
            self.dataSource.append(model)
            
        }
    }
   
}

