//
//  UtilityClass.swift
//  MyanCareDoctor
//
//  Created by Vijay Yadav on 19/12/17.
//  Copyright © 2017 Vijay Yadav. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import SafariServices

/// usr default keys
///
/// - userInfoData: userInfoData description
/// - notificationStatus: notificationStatus description
/// - fcmDeviceToken: fcmDeviceToken description
/// - chatUnReadCount: chatUnReadCount description
/// - apnsDeviceToken: apnsDeviceToken description
private enum UserDefaultEnum : String {
    
    case userInfoData = "userInfoData"
    case language = "language"
    case user_api_hash = "user_api_hash"
}

class UtilityClass: NSObject {
    
    /// open action sheet
    ///
    /// - Parameters:
    ///   - title: title description
    ///   - message: message description
    ///   - onViewController: onViewController description
    ///   - buttonArray: buttonArray description
    ///   - dismissHandler: dismissHandler description
    static func showActionSheetWithTitle(message:String? = "", onViewController:UIViewController?, withButtonArray buttonArray:[String]? = [], dismissHandler:((_ buttonIndex:Int)->())?) -> Void {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        
        var ignoreButtonArray = false
        
        if buttonArray == nil {
            ignoreButtonArray = true
        }
        
        if !ignoreButtonArray {
            for item in buttonArray! {
                
                let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                    guard (dismissHandler != nil) else {
                        return
                    }
                    
                    dismissHandler!(buttonArray!.firstIndex(of: item)!)
                })
  
                alertController.addAction(action)
            }
        }
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        
        onViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithTitle(message:String? = "", onViewController:UIViewController?, withButtonArray buttonArray:[String]? = [], dismissHandler:((_ buttonIndex:Int)->())?) -> Void {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        var ignoreButtonArray = false
        
        if buttonArray == nil {
            ignoreButtonArray = true
        }
        
        if !ignoreButtonArray {
            for item in buttonArray! {
                
                let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                    guard (dismissHandler != nil) else {
                        return
                    }
                    
                    dismissHandler!(buttonArray!.firstIndex(of: item)!)
                })
                
                alertController.addAction(action)
            }
        }
        else {
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
                       
                guard (dismissHandler != nil) else {
                    return
                }
                       
                dismissHandler!(LONG_MAX)
            })
                   
            alertController.addAction(action)
        }
        
        onViewController?.present(alertController, animated: true, completion: nil)
    }

    
    //MARK:- User Info ( SAVE )
       class func saveUserInfoData(userDict : [String:Any]) -> Void {
           let data = NSKeyedArchiver.archivedData(withRootObject: userDict)
           userDefaults.set(data, forKey: UserDefaultEnum.userInfoData.rawValue)
       }
       
       //MARK:- User Info ( GET )
       class func getUserInfoData() -> [String:Any] {
           let data : Data = userDefaults.object(forKey: UserDefaultEnum.userInfoData.rawValue) as! Data
           let userDict : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
           
           return userDict
       }
    
}

