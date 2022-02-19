//
//  NewsView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

//MARK: -News View
class NewsBannerViewController: RootComponentViewController {
    //MARK: -Components
    let textLabel = UILabel()
    
    //MARK: -Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "最新のお知らせ"
        
        textLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        view.addSubview(textLabel)
    }
    
    func onSuccessGetNews(data: Any) {
        let result = data as! NSDictionary
        let newsItem = result["newsItems"] as! NSArray
        let newsItem1 = newsItem[0] as! NSDictionary
        textLabel.text = newsItem1["text"] as? String
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 20, y: 10, width: view.frame.width/2, height: 30)
        textLabel.frame = CGRect(x: 20, y: 40, width: view.frame.width-40, height: 30)
    }
}
