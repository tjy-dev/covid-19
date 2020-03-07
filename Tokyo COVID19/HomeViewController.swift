//
//  HomeViewController.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2020/03/05.
//  Copyright © 2020 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Charts

class HomeViewController: UIViewController, HomeViewControllerDelegate, serverDelegate {
    
    //MARK: -Components
    let scroll = UIScrollView()
    let view0 = ConsoltantAssistViewController()
    let view1 = PositiveNumberViewController()
    let view2 = AttributesViewController()
    let view3 = ExaminationNumberViewController()
    let view4 = CallNumberViewController()
    let view5 = ConsultationViewController()
    let refresh = UIRefreshControl()
    
    //MARK: -Set Up
    override func viewDidLoad() {
        configureNavigationBar()
        configureScollView()
        
        //Access to server and get data
        var server = Server()
        server.delegate = self
        server.getPositiveData()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "都内の最新感染動向"
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: nil)
    }
    
    func configureScollView() {
        scroll.alwaysBounceVertical = true
        scroll.backgroundColor = .background
        view.addSubview(scroll)
        
        let views = [view0,view1,view2,view3,view4]
        for view in views {
            addChild(view)
            didMove(toParent: view)
            self.scroll.addSubview(view.view)
        }
        
        //Delegate
        view0.delegate = self
        view1.delegate = self
        
        //Refresh
        refresh.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        scroll.refreshControl = refresh
        
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        let contentWidth = self.view.frame.width - 20
        let contentHeight = contentWidth*0.9
        
        scroll.frame = view.frame
        view0.view.frame = CGRect(x: 10, y: 20, width: contentWidth, height: 80)
        view1.view.frame = CGRect(x: 10, y: 120, width: contentWidth, height: contentHeight)
        view2.view.frame = CGRect(x: 10, y: view1.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view3.view.frame = CGRect(x: 10, y: view2.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view4.view.frame = CGRect(x: 10, y: view3.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        scroll.contentSize = CGSize(width: view.frame.width, height: view4.view.frame.maxY + 40)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    //MARK: -Action
    func pushToConsultantView() {
        let vc = ConsultViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func endRefresh() {
        refresh.endRefreshing()
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        var server = Server()
        server.delegate = self
        server.getPositiveData()
    }
    
    func onSuccessGet(data: String) {
        endRefresh()
        view1.onSuccessGet(data: data)
        view2.onSuccessGet(data: data)
    }
    
}

protocol HomeViewControllerDelegate {
    //Method when tapped the concultant assist view
    func pushToConsultantView()
}

//MARK: -RootViewController for Components
class RootComponentViewController: UIViewController {
    override func viewDidLayoutSubviews() {
        rightLabel.frame = CGRect(x: view.frame.width - 90, y: 20, width: 70, height: 30)
        label.frame = CGRect(x: 20, y: 20, width: view.frame.width/2, height: 30)
    }
    
    let label = UILabel()
    let rightLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .contentBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.1
        
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.addSubview(label)
        
        rightLabel.textColor = .secondaryLabel
        rightLabel.textAlignment = .right
        rightLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        view.addSubview(rightLabel)
    }
}

//MARK: -View at top
class ConsoltantAssistViewController: RootComponentViewController {
    
    //MARK: -Components
    var delegate: HomeViewControllerDelegate?
    let imageView = UIImageView()

    //MARK: -Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        
        label.text = "自分や家族の症状に不安や心配があればまずは電話相談をどうぞ"
        label.numberOfLines = 0
        
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "chevron.right.circle",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
        view.addSubview(imageView)
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        label.frame = CGRect(x: 20, y: 20, width: view.frame.width - 80, height: view.frame.height - 40)
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        imageView.frame = CGRect(x: view.frame.width - 60, y: 20, width: 40, height: 40)
    }
    
    //MARK: -Action
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        delegate?.pushToConsultantView()
    }
}

//MARK: -Second View
class PositiveNumberViewController: RootComponentViewController, ChartViewDelegate {
    
    //MARK: -Components
    let barChart = BarChartView()
    let segment = UISegmentedControl()
    var number:[Int] = []
    var delegate: HomeViewControllerDelegate?
    
    //MARK: -Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChart()
        label.text = "陽性患者数"
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = barChart.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            let value = number[sliceIndex]
            print(value)
        }
    }
    
    func configureChart() {
        barChart.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        barChart.xAxis.labelTextColor = .label
        barChart.leftAxis.labelTextColor = .label

        // X軸の線、グリッドを非表示
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.xAxis.labelRotationAngle = -45.0
        barChart.xAxis.labelCount = 10
        
        // Y軸の線を非表示
        barChart.leftAxis.drawGridLinesEnabled = true
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawZeroLineEnabled = true
        barChart.leftAxis.axisMinimum = 0.0
        
        barChart.rightAxis.enabled = false
        
        //凡例の設定
        barChart.legend.enabled = false
        
        barChart.doubleTapToZoomEnabled = false
        barChart.pinchZoomEnabled = false
        
        barChart.delegate = self
        
        barChart.noDataTextColor = .label
        view.addSubview(barChart)
    }
    
    func onSuccessGet(data: String) {
        let presentDate:[String] = DataConvert.csvToDateArray(str: data).0
        let finalData:[[Date]] = DataConvert.dateArray(from: presentDate)
        
        rightLabel.text = "\(presentDate.count)"
        
        var labelArray:[String] = []
        var dateArray:[Date] = []
        var patientNumber:[Int] = []
        for days in finalData {
            let format = "M/dd"
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            let dateString = dateFormatter.string(from: days.first!)
            
            if let last = dateArray.last{
                if Calendar.current.date(byAdding: .day, value: 1, to: last) != days.first {
                    
                    // Calculate the remainder between the two value and fill it up
                    // Ex: [[1/1],[1/2],[1/5]] -> [[1/1],[1/2],[1/3],[1/4],[1/5]]
                    
                    let cal = Calendar(identifier: .gregorian)
                    let dif = cal.dateComponents([.day], from: last, to: days.first!)
                    for i in 1..<dif.day!{
                        let date = Calendar.current.date(byAdding: .day, value: i, to: last)
                        dateArray.append(date!)
                        let datestr = dateFormatter.string(from: date!)
                        labelArray.append(datestr)
                        patientNumber.append(0)
                    }
                }
            }
            
            dateArray.append(days.first!)
            labelArray.append(dateString)
            patientNumber.append(days.count)
            self.number = patientNumber
        }
        
        let formatter = ChartStringFormatter()
        formatter.nameValues = labelArray
        self.barChart.xAxis.valueFormatter = formatter
        
        let entries = patientNumber.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemGreen]
        
        let chartData = BarChartData(dataSet: dataSet)
        
        self.barChart.data = chartData
        
        self.barChart.animate(yAxisDuration: 0.5, easingOption: .easeOutQuad)
    }
    
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: label.frame.maxY, width: view.frame.width, height: (view.frame.height - label.frame.maxY - 20))
    }
    
}

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]!
    
    //X Axis to String Value
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}

//MARK: -Third View
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
        table.frame = CGRect(x: 10, y: topBar.view.frame.maxY, width: view.frame.width-20, height: (view.frame.height - topBar.view.frame.maxY - 20))
    }
    
    func onSuccessGet(data: String) {
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


class ExaminationNumberViewController: RootComponentViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "検査実施数"
        rightLabel.text = "106"
    }
}

class CallNumberViewController: RootComponentViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "コールセンター相談件数"
    }
}

class ConsultationViewController: RootComponentViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "窓口相談件数"
    }
}

