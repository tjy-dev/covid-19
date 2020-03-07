//
//  ViewController.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2020/03/05.
//  Copyright © 2020 TJ-Tech. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let menuView = UIView()
    let nv = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = HomeViewController()
        nv.addChild(vc)
        addChild(nv)
        view.addSubview(nv.view)
        nv.didMove(toParent: self)
        nv.isNavigationBarHidden = false
        
        view.addSubview(menuView)
        menuView.backgroundColor = .background
        menuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    override func viewDidLayoutSubviews() {
        menuView.frame = CGRect(x: -view.frame.width/1.3, y: 0, width: view.frame.width/1.3, height: view.frame.height)
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        do {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.menuView.frame = CGRect(x: -self.view.frame.width/1.3, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
            },completion: nil)
        }
    }
    
    @objc func onPan(_ sender: UIScreenEdgePanGestureRecognizer) {
        let transition = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        switch sender.state {
        case .changed:
            if transition.x < view.frame.width/1.3{
                UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    self.menuView.frame = CGRect(x: -self.view.frame.width/1.3 + transition.x, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                }, completion: nil)
            }
        case .cancelled,.ended:
            if velocity.x > 0 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                },completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    self.menuView.frame = CGRect(x: -self.view.frame.width/1.3, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                },completion: nil)
            }
        default:
            return
        }
        
    }
}

