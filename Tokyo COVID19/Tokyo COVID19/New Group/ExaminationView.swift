//
//  ExaminationView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit
import Charts

//MARK: -Fifth View
class ExaminationNumberViewController: RootComponentViewController, ChartViewDelegate {
    
    let barChart = BarChartView()
    var tokyo = [Int]()
    var other = [Int]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 10, y: label.frame.maxY, width: view.frame.width-20, height: (view.frame.height - label.frame.maxY - 20))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChart()
        label.text = "検査実施数"
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
        barChart.setScaleEnabled(false)
        
        barChart.delegate = self
        
        barChart.noDataTextColor = .label
        view.addSubview(barChart)
    }
    
    func onSuccessGetJson(data: Any) {
        let inspections = (data as! NSDictionary)["inspections_summary"] as! NSDictionary
        let inspections_datas = inspections["data"] as! NSDictionary
        let tokyo_data = inspections_datas["都内"] as! NSArray
        let other_data = inspections_datas["その他"] as! NSArray
        let label_data = inspections["labels"] as! NSArray
        
        var tokyo:[Int] = []
        var other:[Int] = []
        var appearDate:[String] = []
        var number = 0
        
        for data in tokyo_data{
            let dict_data = data as! Int
            tokyo.append(dict_data)
            number += dict_data
        }
        for data in other_data{
            let dict_data = data as! Int
            other.append(dict_data)
            number += dict_data
        }
        for data in label_data{
            let dict_data = data as! String
            appearDate.append(dict_data)
        }
        
        self.tokyo = tokyo
        self.other = other
        
        setBarChartData(appearDate, tokyo, other)
        
        rightLabel.text = String(number)
    }
    
    func setBarChartData(_ label:[String],_ data1:[Int],_ data2:[Int]){
        let formatter = ChartStringFormatter()
        formatter.nameValues = label
        self.barChart.xAxis.valueFormatter = formatter
        
        let count = data1.count
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let val1 = Double(data1[i])
            let val2 = Double(data2[i])
            
            return BarChartDataEntry(x: Double(i), yValues: [val1, val2])
        }
        
        let dataSet = BarChartDataSet(entries: yVals)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.myGreen,.systemGreen]
        dataSet.highlightEnabled = false
        let chartData = BarChartData(dataSet: dataSet)

        
        self.barChart.data = chartData
        
        self.barChart.animate(yAxisDuration: 0.5, easingOption: .easeOutQuad)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = barChart.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            let value = tokyo[sliceIndex]
            print(value)
        }
    }
}

