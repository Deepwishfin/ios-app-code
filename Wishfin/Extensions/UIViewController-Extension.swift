//
//  UIViewController-Extension.swift
//  WaltzinUser
//
//  Created by Sumit Sharma on 10/04/18.
//  Copyright © 2018 Vijay Yadav   All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    struct BarButtonTypes: OptionSet {
        let rawValue: Int
        
        static let searchButton = BarButtonTypes(rawValue: 1 << 0)
        static let addBudEChatButton = BarButtonTypes(rawValue: 1 << 1)
    }
    
    enum BarButtonPosition {
        case left
        case right
    }
    

    
    var backBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "backWhite"), style: .plain, target: self, action: #selector(onBackButtonAction))
        
     //   let button = UIBarButtonItem (title :"Back", style: .plain, target: self, action: #selector(onBackButtonAction))
        button.tintColor = UIColor(red: 239.0/255, green: 150.0/255, blue: 64.0/255, alpha: 1.0)
       // button.titleLabel.font =  UIFont(name: "gameOver", size: 16)
        
     //   button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Open Sans-Regular", size: 17.0)!], for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = button
        return button
    }
    

    
    var crossBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "cancelCrossIcon"), style: .plain, target: self, action: #selector(onCrossButtonAction))
        self.navigationItem.leftBarButtonItem = button
        return button
    }
    
    var threeDotBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "moreIcon"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        return button
    }
    
    var videoCallBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "videoCallicon"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        return button
    }
    
    var favBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "favIcon"), style: .plain, target: nil, action: nil)
        return button
    }
    
    var searchBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: UIImage.init(named: "search-icon"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        return button
    }
    
    var addBudEChatBarButton: UIBarButtonItem {
        let button = UIBarButtonItem (image: #imageLiteral(resourceName: "addBudEChatIcon"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        return button
    }
    
    var crossButton: UIButton {
        let button = UIButton (frame: CGRect (x: 15.5 * ScaleFactorX, y: 33.5 * ScaleFactorX, width: 10, height: 10))
        button.setImage(#imageLiteral(resourceName: "cancelCrossIcon"), for: .normal)
        button.sizeToFit()
        button.frame = CGRect (x: 0, y: 0, width: (15.5 * ScaleFactorX * 2) + button.frame.size.width, height: (33.5 * ScaleFactorX * 2) + button.frame.size.height)
        button.addTarget(self, action: #selector(onCrossButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    var backButton: UIButton {
        let button = UIButton (frame: CGRect (x: 15.5 * ScaleFactorX, y: 33.5 * ScaleFactorX, width: 10, height: 10))
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        button.sizeToFit()
        button.frame = CGRect (x: 0, y: 0, width: (15.5 * ScaleFactorX * 2) + button.frame.size.width, height: (33.5 * ScaleFactorX * 2) + button.frame.size.height)
        button.addTarget(self, action: #selector(onBackButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    func addMultipleBarButtons(types: BarButtonTypes, position: BarButtonPosition) {
        if types.contains(.searchButton) {
            
        }
    }
    
    @objc func onBackButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    


    
    @objc func onCrossButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isFirstInHierarchy() -> Bool {
        guard self.navigationController != nil else {
            return true
        }
        return self.navigationController!.viewControllers.first == self
    }
    
    func showNavigationBar() {
        guard self.navigationController != nil else {
            return
        }
        self.navigationController? .setNavigationBarHidden(false, animated: true)
        
    }
    
    func hideNavigationBar() {
        guard self.navigationController != nil else {
            return
        }
        self.navigationController? .setNavigationBarHidden(true, animated: true)
    }
    
    func addMoreBarButtonItem(contents: [String], delegate: UIViewController) {
        let button = threeDotBarButton
        button.target = delegate
        button.tag = 0
        button.action = #selector(onMoreBarButtonAction(_:))
    }
    
    @objc func onMoreBarButtonAction(_ barButton: UIBarButtonItem) {
        
    }
    
    func setup_API_LIKE(postId t_post_id : String, loginUserId t_post_like_id : String, typeStr : String, viewController:UIViewController)
     {
        
        
    }
}

extension UIColor {
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let alphaValue = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1;

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}

