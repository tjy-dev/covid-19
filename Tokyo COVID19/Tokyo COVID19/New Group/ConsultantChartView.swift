//
//  ConsultantChartView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

//MARK: -Seventh View
class ConsultationViewController: RootComponentViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "窓口相談件数"
    }
}
