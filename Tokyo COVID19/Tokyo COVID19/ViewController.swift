//
//  ViewController.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2020/03/05.
//  Copyright © 2020 TJ-Tech. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, ViewControllerDelegate {
    
    //MARK: -Components
    let menuView = UIView()
    let coverView = UIView()
    let nv = UINavigationController()
    var menuState: menuStateEnum = .hidden
    enum menuStateEnum {
        case hidden
        case appear
    }
    
    
    //MARK: -Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = HomeViewController()
        nv.addChild(vc)
        addChild(nv)
        vc.delegate = self
        view.addSubview(nv.view)
        nv.didMove(toParent: self)
        nv.isNavigationBarHidden = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        
        
        view.addSubview(coverView)
        coverView.alpha = 0
        coverView.backgroundColor = .black

        view.addSubview(menuView)
        menuView.backgroundColor = .background
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
    
    //MARK: -Set State
    override func viewDidLayoutSubviews() {
        coverView.frame = view.frame
        switch menuState {
        case .appear:
            menuView.frame = CGRect(x: 0, y: 0, width: view.frame.width/1.3, height: view.frame.height)
        case .hidden:
            menuView.frame = CGRect(x: -view.frame.width/1.3, y: 0, width: view.frame.width/1.3, height: view.frame.height)
        }
    }
    
    func hideMenu() {
        menuState = .hidden
        do {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.coverView.alpha = 0
                self.menuView.frame = CGRect(x: -self.view.frame.width/1.3, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
            },completion: nil)
        }
    }
    
    func showMenu() {
        menuState = .appear
        do {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.coverView.alpha = 0.4
                self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
            },completion: nil)
        }
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        hideMenu()
    }
    
    @objc func onPan(_ sender: UIScreenEdgePanGestureRecognizer) {
        if menuState == .hidden {
            let transition = sender.translation(in: view)
            let velocity = sender.velocity(in: view)
            switch sender.state {
            case .changed:
                if transition.x < view.frame.width/1.3{
                    UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                        self.coverView.alpha = (transition.x/(self.view.frame.width/1.3))*0.4
                        self.menuView.frame = CGRect(x: -self.view.frame.width/1.3 + transition.x, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                    }, completion: nil)
                }else{
                    UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                        self.coverView.alpha = 0.4
                        self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                    }, completion: nil)
                }
            case .cancelled,.ended:
                if velocity.x > 0 {
                    menuState = .appear
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                        self.coverView.alpha = 0.4
                        self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                    },completion: nil)
                }else{
                    menuState = .hidden
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                        self.coverView.alpha = 0
                        self.menuView.frame = CGRect(x: -self.view.frame.width/1.3, y: 0, width: self.view.frame.width/1.3, height: self.view.frame.height)
                    },completion: nil)
                }
            default:
                return
            }
        }
    }
}

protocol ViewControllerDelegate {
    func showMenu()
}
