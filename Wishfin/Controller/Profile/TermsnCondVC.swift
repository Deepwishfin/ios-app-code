//
//  TermsnCondVC.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TermsnCondVC: UIViewController {

    @IBOutlet weak var termWebView: UIWebView!
    var isSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsApi()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Api call for get
    func termsApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            var url = ""
            if isSignUp {
                 url = UrlName.baseUrl + UrlName.termSignup
            }
            else{
                url = UrlName.baseUrl + UrlName.terms
            }
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "SUCCESS" {
                    if let resultDic = jsonValue["result"] {
                        self.termWebView.loadHTMLString(resultDic["content"].stringValue, baseURL: nil)
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
}

// MARK: UIWebViewDelegate Methods
extension TermsnCondVC : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showHUD(progressLabel: "Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading{
            self.dismissHUD(isAnimated: true)
        }
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let url = request.url, navigationType == .linkClicked else { return true }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return false
    }
}

extension TermsnCondVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.termsApi()
            }
            else {
               // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
