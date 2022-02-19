//
//  ConsoltantView.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2022/02/19.
//  Copyright © 2022 TJ-Tech. All rights reserved.
//

import Foundation
import UIKit

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
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)

        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "chevron.right.circle",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
        view.addSubview(imageView)
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        label.frame = CGRect(x: 20, y: 20, width: view.frame.width - 80, height: view.frame.height - 40)
        
        imageView.frame = CGRect(x: view.frame.width - 60, y: 20, width: 40, height: 40)
    }
    
    //MARK: -Action
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        delegate?.pushToConsultantView()
    }
}
