//
//  UIViewController.swift
//  Wishfin
//
//  Created by Wishfin on 14/6/19..
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Toast_Swift

extension UIViewController     {
    
    func showToast(messsage:String, position:ToastPosition){
        let style = ToastStyle()
        self.view.makeToast(messsage, duration: 3.0, position:position, style:style)
    }
    
    // Showing loader on API call
    //
    // - Parameter progressLabel: Loader message
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        //progressHUD.bezelView.color = primaryColor()
        //progressHUD.contentColor = UIColor.white
        progressHUD.label.text = progressLabel
    }
    
    
    // Dismiss loader after API response
    //
    // - Parameter isAnimated: animation
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
    
    /// Method to show alert when no internet connection
    func showNoInternetAlert(){
        let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showPlayerWarningAlert(){
        let alertView = UIAlertController(title: "Warning!", message: "Please Select player first", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
   
    
   /// Showing generic alert
   ///
   /// - Parameters:
   ///   - title: title of alert
   ///   - message: description of alert
   @objc func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: AlertField.okString, style: .default))
        present(ac, animated: true)
    }
    
    /// Api call for getting token
     func getTokenApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let url : String = UrlName.baseUrl + UrlName.oAuth
            //Live
            let params = ["username":"wfexpenseapp","password": "8aNKX7vDu758R6Vu","client_id": "wfexpenseapp","grant_type": "password"]
            //Stage
//            let params = ["username":"wishfin","password": "qwer1234","client_id": "wishfin","grant_type": "password"]
            print("Parameters:" , params)

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: [:], url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
                    let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
                        
                    })
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)

                    return
                }
                print(jsonValue)
                if let accessToken = jsonValue[DefaultsKey.accessToken]?.stringValue{
                    Defaults.setAccessToken(accessToken)
                } else {
                    return
                }
                
            })
        }else{
            let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
            let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
}

//Class ends here
