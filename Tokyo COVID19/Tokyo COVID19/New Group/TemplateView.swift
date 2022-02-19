//
//  TemplateView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

//MARK: -RootViewController for Components
class RootComponentViewController: UIViewController {
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
    
    override func viewDidLayoutSubviews() {
        rightLabel.frame = CGRect(x: view.frame.width - 120, y: 20, width: 100, height: 30)
        label.frame = CGRect(x: 20, y: 20, width: view.frame.width/2, height: 30)
    }
}
