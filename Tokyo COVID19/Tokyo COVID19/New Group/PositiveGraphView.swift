//
//  PositiveGraphView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit
import Charts

//MARK: -Third View
class PositiveNumberViewController: RootComponentViewController, ChartViewDelegate {
    
    //MARK: -Components
    let barChart = BarChartView()
    let segment = UISegmentedControl()
    var number:[Int] = []
    
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
        barChart.setScaleEnabled(false)

        barChart.delegate = self
        
        barChart.noDataTextColor = .label
        view.addSubview(barChart)
    }
    
    /*func onSuccessGet(data: String) {
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
    }*/
    
    func onSuccessGetJson(data: Any) {
        let patients_summary = (data as! NSDictionary)["patients_summary"] as! NSDictionary
        let patients_number_data = patients_summary["data"] as! NSArray
        
        var patientNumber:[Int] = []
        var labelArray:[String] = []
        
        for patients_data in patients_number_data {
            let dict = patients_data as! NSDictionary
            patientNumber.append(dict["小計"] as! Int)
            
            var dateString = dict["日付"] as! String
            dateString = String(dateString.dropLast(14))
            
            let format = "yyyy-MM-dd"
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: dateString)
            
            dateFormatter.dateFormat = "M/dd"
            labelArray.append(dateFormatter.string(from: date!))
        }
        
        setBarChartData(labelArray, patientNumber)
        
        self.number = patientNumber
        
        rightLabel.text = "\(patientNumber.count)"
    }
    
    func setBarChartData(_ label:[String],_ data1:[Int]) {
        let formatter = ChartStringFormatter()
        formatter.nameValues = label
        self.barChart.xAxis.valueFormatter = formatter
        
        let entries = data1.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.systemGreen]
        dataSet.highlightColor = .myGreen
        
        let chartData = BarChartData(dataSet: dataSet)
        
        self.barChart.data = chartData
        
        self.barChart.animate(yAxisDuration: 0.5, easingOption: .easeOutQuad)
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 10, y: label.frame.maxY, width: view.frame.width-20, height: (view.frame.height - label.frame.maxY - 20))
    }
    
}

