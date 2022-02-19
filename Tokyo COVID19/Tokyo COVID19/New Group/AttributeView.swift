//
//  AttributeView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

//MARK: -Fourth View
class AttributesViewController: RootComponentViewController,UITableViewDataSource {
    
    var table: UITableView!
    var presentDate:[String] = []
    var residence:[String] = []
    var age:[String] = []
    var sex:[String] = []
    let topBar = TableViewTopBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "陽性患者の属性"
        
        configureTable()
    }
    
    func configureTable() {
        addChild(topBar)
        topBar.didMove(toParent: self)
        view.addSubview(topBar.view)
        
        table = UITableView()
        table.backgroundColor = .clear
        table.dataSource = self
        table.allowsSelection = false
        table.rowHeight = 45
        table.register(TableViewCell.self, forCellReuseIdentifier: "Atributes_Cell")
        view.addSubview(table)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Atributes_Cell", for: indexPath) as! TableViewCell
        cell.configure(date: presentDate[indexPath.row], residence: residence[indexPath.row], age: age[indexPath.row], sex: sex[indexPath.row],indexPath:indexPath)
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topBar.view.frame = CGRect(x: 10, y: label.frame.maxY, width: view.frame.width-20, height: 45)
        table.frame = CGRect(x: 10, y: topBar.view.frame.maxY, width: view.frame.width-20, height: (view.frame.height - topBar.view.frame.maxY - 10))
    }
    
    /*func onSuccessGet(data: String) {
        let result = DataConvert.csvToDateArray(str: data)
        let rawPresentDate = result.0
        presentDate = []
        residence = result.1
        age = result.2
        sex = result.3
        
        for day in rawPresentDate {
            let format = "yyyy-MM-dd"
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: day)
            
            let format2 = "M/dd"
            let dateFormatter2: DateFormatter = DateFormatter()
            dateFormatter2.dateFormat = format2
            let compactDate = dateFormatter2.string(from: date!)
            presentDate.append(compactDate)
        }
        
        rightLabel.text = "\(presentDate.count)"
        table.reloadData()
    }*/
    
    func onSuccessGetJson(data: Any) {
        let json = data as! NSDictionary
        let patients_summary = json["patients_summary"] as! NSDictionary
        //let summary = patients_summary["patients"] as! NSDictionary
        let patients_exclusive_data = patients_summary["data"] as! NSArray
        
        var parientAge:[String] = []
        var parientSex:[String] = []
        var residence:[String] = []
        var appearDate:[String] = []
        
        //for patients_data in patients_exclusive_data {
        for i in 0..<patients_exclusive_data.count {
            let dict = patients_exclusive_data[i] as! NSDictionary
            
            let dateString = dict["date"] as! String
            
            var dict1 = "不明"
            var dict2 = "不明"
            var dict3 = "不明"
            
            if dict["居住地"] as? String? != nil {
                dict1 = dict["居住地"] as! String
            }
            if dict["年代"] as? String? != nil {
                dict2 = dict["年代"] as! String
            }
            if dict["性別"] as? String? != nil {
                dict3 = dict["性別"] as! String
            }
            residence.append(dict1)
            parientAge.append(dict2)
            parientSex.append(dict3)
            
            let format = "yyyy-MM-dd"
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: dateString)
            
            dateFormatter.dateFormat = "M/dd"
            appearDate.append(dateFormatter.string(from: date!))
        }
        
        self.presentDate = appearDate
        self.residence = residence
        self.age = parientAge
        self.sex = parientSex
        
        rightLabel.text = "\(parientAge.count)"
        table.reloadData()
    }
}

class TableViewTopBar: UIViewController {
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    
    let line = UIView()
    
    override func viewDidLoad() {
        let labels = [label1,label2,label3,label4]
        for label in labels {
            label.textColor = .label
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            view.addSubview(label)
        }
        label1.text = "日付"
        label2.text = "居住地"
        label3.text = "年代"
        label4.text = "性別"
        
        line.backgroundColor = .systemGray
        view.addSubview(line)
    }
    
    override func viewDidLayoutSubviews() {
        let width = view.frame.width/8
        let height = view.frame.height
        label1.frame = CGRect(x: 10, y: 0, width: width*2-10, height: height)
        label2.frame = CGRect(x: width*2, y: 0, width: width*3, height: height)
        label3.frame = CGRect(x: width*5, y: 0, width: width*1.5, height: height)
        label4.frame = CGRect(x: width*6.5, y: 0, width: width*1.5, height: height)
        line.frame = CGRect(x: 0, y: view.frame.height - 0.5, width: view.frame.width, height: 0.5)
    }
}

class TableViewCell: UITableViewCell {
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
                
        let width = frame.width/8
        let height = frame.height
        
        let labels = [label1,label2,label3,label4]
        for label in labels {
            label.textColor = .label
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            contentView.addSubview(label)
        }
        label1.frame = CGRect(x: 10, y: 0, width: width*2-10, height: height)
        label2.frame = CGRect(x: width*2, y: 0, width: width*3, height: height)
        label3.frame = CGRect(x: width*5, y: 0, width: width*1.5, height: height)
        label4.frame = CGRect(x: width*6.5, y: 0, width: width*1.5, height: height)
    }
    
    func configure(date: String,residence:String,age:String,sex:String,indexPath:IndexPath) {
        label1.text = date
        label2.text = residence
        label3.text = age
        label4.text = sex
        
        contentView.backgroundColor = .contentBackground
        if indexPath.row%2 == 1{
            contentView.backgroundColor = .secondarySystemFill
        }
    }
}
