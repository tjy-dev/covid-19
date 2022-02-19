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
    let view0 = NewsBannerViewController()
    let view1 = ConsoltantAssistViewController()
    let view2 = PositiveNumberViewController()
    let view3 = AttributesViewController()
    let view4 = ExaminationNumberViewController()
    let view5 = StateViewController()
    let view6 = ConsultationViewController()
    let view7 = CallNumberViewController()
    let refresh = UIRefreshControl()
    
    var delegate:ViewControllerDelegate?
    
    //MARK: -Set Up
    override func viewDidLoad() {
        configureNavigationBar()
        configureScollView()
        
        //Access to server and get data
        var server = Server()
        server.delegate = self
        //server.getPositiveData()
        server.getJsonData()
        server.getNews()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "都内の最新感染動向"
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(tappedLeftButton))
    }
    
    func configureScollView() {
        scroll.alwaysBounceVertical = true
        scroll.backgroundColor = .background
        view.addSubview(scroll)
        
        let views = [view0,view1,view2,view3,view4,view5,view6,view7]
        for view in views {
            addChild(view)
            didMove(toParent: view)
            self.scroll.addSubview(view.view)
        }
        
        //Delegate
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
        view1.view.frame = CGRect(x: 10, y: view0.view.frame.maxY + 20, width: contentWidth, height: 80)
        view2.view.frame = CGRect(x: 10, y: view1.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view3.view.frame = CGRect(x: 10, y: view2.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view4.view.frame = CGRect(x: 10, y: view3.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view5.view.frame = CGRect(x: 10, y: view4.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view6.view.frame = CGRect(x: 10, y: view5.view.frame.maxY + 20, width: contentWidth, height: contentHeight)
        view7.view.frame = CGRect(x: 10, y: view6.view.frame.maxY + 20, width: contentWidth, height: contentHeight)

        scroll.contentSize = CGSize(width: view.frame.width, height: view7.view.frame.maxY + 40)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    //MARK: -Action
    @objc func tappedLeftButton() {
        delegate?.showMenu()
    }
    
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
        server.getJsonData()
        server.getNews()
    }
    
    func onSuccessGetJson(data: Any) {
        endRefresh()
        view2.onSuccessGetJson(data: data)
        //view3.onSuccessGetJson(data: data)
        view4.onSuccessGetJson(data: data)
        //view5.onSuccessGetJson(data: data)
    }
    
    func onSuccessGetNews(data: Any) {
        view0.onSuccessGetNews(data: data)
    }
    
    /*func onSuccessGet(data: String) {
        endRefresh()
        view1.onSuccessGet(data: data)
        view2.onSuccessGet(data: data)
    }*/
    
}

protocol HomeViewControllerDelegate {
    //Method when tapped the concultant assist view
    func pushToConsultantView()
}

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]!
    
    //X Axis to String Value
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}
