//
//  LoginVC.swift
//  Wishfin
//
//  Created by Wishfin on 10/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var continButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        getLoginTokenApi()
        loginView.setShadowOnAllSidesOfView(shadowSizeValue:10)
        mobileTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if !isMobileNumberValid(mobileNumberData: text) {
                    floatingLabelTextField.errorMessage = AlertField.validMobileString
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        if mobileTextField.text!.isEmpty{
            mobileTextField.errorMessage = AlertField.digitMobileString
        }
        else if !isMobileNumberValid(mobileNumberData: mobileTextField.text!) {
            mobileTextField.errorMessage = AlertField.validMobileString
        }
        else {
             checkEmailMobileApi()
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension LoginVC {
    /// Api call for getting token
    func getLoginTokenApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let url : String = UrlName.baseUrl + UrlName.oAuth
            //Live
            let params = ["username":"wfexpenseapp","password": "8aNKX7vDu758R6Vu","client_id": "wfexpenseapp","grant_type": "password"]
            //Stage
//            let params = ["username":"wishfin","password": "qwer1234","client_id": "wishfin","grant_type": "password"]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: [:], url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                if status == "Request timeout"{
                    let alertView = UIAlertController(title: "Request timeout!", message: "Please try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
                        self.getLoginTokenApi()
                    })
                    alertView.addAction(action)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                        print("cancel")
                    })
                    alertView.addAction(cancel)
                     self.present(alertView, animated: true, completion: nil)
                    return
                }
                guard let jsonValue = json?.dictionaryValue else {
                    self.showToeknNoIntAlert()
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
            self.showToeknNoIntAlert()
        }
    }
    /// Api for email/mobile
    func checkEmailMobileApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let url : String = UrlName.baseUrl + UrlName.checkEmailMobile
            let params = ["mobile_number":self.mobileTextField.text!,] as [String : Any]
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                if status == "Request timeout"{
                    self.dismissHUD(isAnimated: true)
                    let alertView = UIAlertController(title: "Request timeout!", message: "Please try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
                        self.checkEmailMobileApi()
                    })
                    alertView.addAction(action)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                        print("cancel")
                    })
                    alertView.addAction(cancel)
                     self.present(alertView, animated: true, completion: nil)
                    return
                }
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoInternetAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                        let otpVC = OTPVC.init(nibName: OTPVC.className(), bundle: nil)
                        otpVC.mobileString = self.mobileTextField.text!
                        otpVC.isComingFromLogin = true
                        self.navigationController?.pushViewController(otpVC, animated: true)
                }
                else {
                    Defaults.setLaunched(true)
                    let reg1VC = Registration1VC.init(nibName: Registration1VC.className(), bundle: nil)
                    reg1VC.mobileNumber = self.mobileTextField.text!
                    self.navigationController?.pushViewController(reg1VC, animated: true)
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}
extension LoginVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.checkEmailMobileApi()
            }
            else {
             //   self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToeknNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.getLoginTokenApi()
            }
            else {
                self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
