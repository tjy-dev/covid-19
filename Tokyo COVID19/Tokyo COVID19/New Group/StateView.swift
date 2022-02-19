//
//  StateView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

//MARK: -Second View
class StateViewController: RootComponentViewController {
    
    let topView = UIView()
    let secondView = UIView()
    
    let child1 = UIView()
    let child2 = UIView()
    let child3 = UIView()
    let child4 = UIView()
    let child5 = UIView()
    
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let label4 = UILabel()
    let label5 = UILabel()
    let label6 = UILabel()
    let label7 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "陽性感染者の状況"
        
        let views = [label1:topView,label2:secondView,label3:child1,label4:child2,label5:child3,label6:child4,label7:child5]
        for (label,view) in views {
            self.view.addSubview(view)
            view.layer.borderColor = UIColor.systemGreen.cgColor
            view.layer.borderWidth = 3
            view.layer.cornerRadius = 3
            view.layer.cornerCurve = .continuous
            view.addSubview(label)
            label.textAlignment = .center
        }
        topView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func onSuccessGetJson(data:Any) {
        let result = (data as! NSDictionary)["main_summary"] as! NSDictionary
        label1.text = String(result["value"] as! Int)
        
        let ill = (result["children"] as! NSArray)[0] as! NSDictionary
        label2.text = String(ill["value"] as! Int)
        
        let illExclusive = ill["children"] as! NSArray
        let illExDict = illExclusive[0] as! NSDictionary
        label3.text = String(illExDict["value"] as! Int)
        
        let inHospital = illExDict["children"] as! NSArray
        label4.text = String((inHospital[0] as! NSDictionary)["value"] as! Int)
        label5.text = String((inHospital[1] as! NSDictionary)["value"] as! Int)
        
        let outOfHospital = illExclusive[1] as! NSDictionary
        label6.text = String(outOfHospital["value"] as! Int)
        
        let couldntSurvive = illExclusive[2] as! NSDictionary
        label7.text = String(couldntSurvive["value"] as! Int)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding:CGFloat = 4
        
        let width = view.frame.width - 20
        let width2 = width/2-padding/2//2分割
        let width4 = width2/2-padding/2//4分割
        
        let height = (view.frame.height-label.frame.maxY-30)/5
        let height2 = height*2 + padding
        let height3 = height*3 + padding*2
        
        let views = [label1:topView,label2:secondView,label3:child1,label4:child2,label5:child3,label6:child4,label7:child5]
        for (label,view) in views {
            label.frame = CGRect(x: 0, y: 0, width: width4-10, height: height-10)
            label.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        }
        
        topView.frame = CGRect(x: 10, y: label.frame.maxY + padding, width: width, height: height)
        secondView.frame = CGRect(x: 10, y: topView.frame.maxY + padding, width: width, height: height)
        child1.frame = CGRect(x: 10, y: secondView.frame.maxY + padding, width: width2, height: height)
        
        child2.frame = CGRect(x: 10, y: child1.frame.maxY + padding, width: width4, height: height2)
        child3.frame = CGRect(x: child2.frame.maxX + padding, y: child1.frame.maxY + padding, width: width4, height: height2)
        
        child4.frame = CGRect(x: child3.frame.maxX + padding, y: secondView.frame.maxY + padding, width: width4, height: height3)
        child5.frame = CGRect(x: child4.frame.maxX + padding, y: secondView.frame.maxY + padding, width: width4, height: height3)
    }
}
