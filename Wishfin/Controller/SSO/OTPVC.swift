//
//  OTPVC.swift
//  Wishfin
//
//  Created by Wishfin on 09/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var backOtpButton: UIButton!
    @IBOutlet weak var resendOtpButton: UIButton!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var forthTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: Variables
    var isComingFromLogin = false
    var isGetOtp = false
    var isTimerRunning = false
    var mobileString = ""
    var emailString = ""
    var fName = ""
    var lName = ""
    var mName = ""
    var dobString = ""
    var panString = ""
    var seconds = 0
    var timer : Timer?
    var otpText = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    /// Setting View
    func setupView(){
        otpView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        let mob = self.mobileString.replace_fromStart(str: self.mobileString, endIndex: 6, With: "********")
        otpLabel.text = "We have sent an otp on \(mob)"
        firstTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        secondTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        thirdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        forthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        getOtpAPI()
    }

    //MARK: Internal Method
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        submit()
    }
    
    func submit(){
        self.view.endEditing(true)
        if ((self.firstTextField.text?.isEmpty)! || (self.secondTextField.text?.isEmpty)! || (self.thirdTextField.text?.isEmpty)! || (self.forthTextField.text?.isEmpty)!)  {
            self.view.makeToast(AlertField.emptyOtpString, duration: 3.0, position: .bottom)
        }
        else {
            self.continueButton.isEnabled = false
            if isComingFromLogin {
                loginApi()
            }
            else {
                getOtpVerify()
            }
        }
    }
    
    @IBAction func resendBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.firstTextField.text = ""
        self.secondTextField.text = ""
        self.thirdTextField.text = ""
        self.forthTextField.text = ""
        getTokenApi()
        getOtpAPI()
    }
    
    
    func runTimer() {
        guard timer == nil else { return }
        seconds = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(OTPVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            resendOtpButton.setTitle("Resend otp", for: .normal)
            resendOtpButton.isUserInteractionEnabled = true
            self.backOtpButton.isHidden = false
            self.stopTimer()
        } else {
            seconds -= 1
            if seconds < 60 {
                resendOtpButton.setTitle("Resend otp in: \(seconds) sec", for: .normal)
                resendOtpButton.isUserInteractionEnabled = false
                self.backOtpButton.isHidden = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        if text?.utf16.count ?? 0 >= 1{
            switch textField{
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                thirdTextField.becomeFirstResponder()
            case thirdTextField:
                forthTextField.becomeFirstResponder()
            case forthTextField:
                forthTextField.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }

    }
}

extension OTPVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("***** I am End now")
        if #available(iOS 12.0, *) {
            if (!(self.firstTextField.text?.isEmpty)! && !(self.secondTextField.text?.isEmpty)! && !(self.thirdTextField.text?.isEmpty)! && !(self.forthTextField.text?.isEmpty)!)  {
                submit()
            }
        }
    }
}


extension OTPVC {
    
    //MARK: Api call for getting Schools
    func getOtpAPI() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Getting otp")
            var type = ""
            if isComingFromLogin {
                type = "signin_app"
            }
            else {
                type = "cibil_signup_mobile"
            }
            let version =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2"
            let getOtpURL : String = UrlName.baseUrl + UrlName.getOtp
            let params = ["email_mobile":mobileString,"type":type,
                          "device_type" : "iOS","hash":"", "app_version":version]
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getOtpURL, method: .post, parameters: params, completionHandler: { (json, status) in
                if status == "Request timeout"{
                    self.dismissHUD(isAnimated: true)
                    let alertView = UIAlertController(title: "Request timeout!", message: "Please try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
                        self.getOtpAPI()
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
                    return
                }
                print(jsonValue)
                if (jsonValue["status"] == "success") {
                    if let resultDic = jsonValue["result"] {
                        print("***********one time code***********")
                        Defaults.removeSecurityToken()
                        Defaults.setSecurityToken(resultDic["secret_key"].stringValue)
                        self.isGetOtp = true
                        self.firstTextField.becomeFirstResponder()
                        self.textFieldDidChange(self.firstTextField)
                    }
                }
                else if (jsonValue["status"] == "failed"){
                    if (jsonValue["message"] == "ok" || jsonValue["message"] == "OK"){
                        if let resultDic = jsonValue["result"] {
                            if (resultDic["otp_status"] == "Same OTP Send" || resultDic["otp_status"] == "OTP Already Sent"){
                                Defaults.removeSecurityToken()
                                Defaults.setSecurityToken(resultDic["secret_key"].stringValue)
                                self.isGetOtp = true
                                self.firstTextField.becomeFirstResponder()
                                self.textFieldDidChange(self.firstTextField)

                            }
                        }
                    }
                }
                self.runTimer()
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    /// Api for login
    func loginApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.continueButton.isEnabled = false
            self.showHUD(progressLabel: AlertField.loaderString)
            let getOtpURL : String = UrlName.baseUrl + UrlName.login
            let otpString = firstTextField.text! + secondTextField.text! + thirdTextField.text! + forthTextField.text!
            var securityToken = ""
            if let token = Defaults.getSecurityToken(){
                securityToken = token
            }
            let version =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2"
            let params = ["email_mobile":self.mobileString,"otp_password":otpString,"case":"MO","type":"signin_app","secret_key":securityToken, "device_type":"iOS","app_version":version] as [String : Any]
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getOtpURL, method: .post, parameters: params, completionHandler: { (json, status) in
                if status == "Request timeout"{
                    self.dismissHUD(isAnimated: true)
                    let alertView = UIAlertController(title: "Request timeout!", message: "Please try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
                        self.loginApi()
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
                    self.continueButton.isEnabled = true
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        let loginModel = LoginModel(json: resultDic)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginModel)
                        UserDefaults.standard.set(encodedData, forKey: DefaultsKey.loginDetails)
                        Defaults.setSession(true)
                        UserDefaults.standard.set("login", forKey: DefaultsKey.loginType)
                        Switcher.updateRootVC(SelIndex: 0)
                    }
                }
                else {
                    self.showToast(messsage: jsonValue["message"]?.stringValue ?? "", position: .bottom)
                }
                self.continueButton.isEnabled = true
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }

    /// Api call for otp verify
    func getOtpVerify() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.continueButton.isEnabled = false
            let url : String = UrlName.baseUrl + UrlName.otpVerify
            var securityToken = ""
            if let token = Defaults.getSecurityToken(){
                securityToken = token
            }
            let otpString = firstTextField.text! + secondTextField.text! + thirdTextField.text! + forthTextField.text!
            let version =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2"
            let params = ["email_mobile":mobileString,"type":"cibil_signup_mobile","otp":otpString,"case":"MO","secret_key":securityToken,
                          "device_type" : "iOS","hash":"","app_version":version]
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.showNoInternetAlert()
                    self.continueButton.isEnabled = true
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    self.signupApi()
                }
                else {
                    self.showToast(messsage: jsonValue["message"]?.stringValue ?? "", position: .bottom)
                }
               self.continueButton.isEnabled = true
            })
        }else{
            let alertView = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
            let action = UIAlertAction(title: AlertField.okString, style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    /// Api for signup
    func signupApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getsignupURL : String = UrlName.baseUrl + UrlName.signup
            let params = [
                "first_name":self.fName,
                "middle_name":self.mName,
                "last_name":self.lName,
                "date_of_birth":self.dobString,
                "gender":"1",
                "pancard":self.panString,
                "email_id":self.emailString,
                "mobile_number":self.mobileString,
                "is_pancard_kyc":"0",
                "pancard_holder_name":self.fName + " " + self.lName,
                "type":"cibil",
                "correspondence_address":"Default",
                "correspondence_pincode":"400001",
                "correspondence_state":"MH",
                "correspondence_city":"Default",
                "signup_source":"cibil",
                "resource_pagename":"cibil_wishfin_iOS",
                "resource_source":"cibil_wishfin_iOS",
                "resource_ip_address":getIPAddress(),
                "resource_querystring":"",
                "utm_source":"",
                "utm_medium":"",
                "referrer_address":"wishfin_iOS",
                "source":"wishfin_iOS",
                "querystring":"",
                "is_system_generated":1,
                ] as [String : Any]
            
            print("signupApi params", params)
            let headers = ["Authorization": Defaults.getHeader()]

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getsignupURL, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoInternetAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        UserDefaults.standard.set(self.panString, forKey: "pancard")
                        UserDefaults.standard.set("1987-10-12", forKey: "dob")
                        let loginModel = LoginModel(json: resultDic)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: loginModel)
                        UserDefaults.standard.set(encodedData, forKey: DefaultsKey.loginDetails)
                        Defaults.setSession(true)
                        UserDefaults.standard.set("signup", forKey: DefaultsKey.loginType)
                        Switcher.updateRootVC(SelIndex: 0)
                    }
                }
                else {
                    self.showToast(messsage: jsonValue["message"]?.stringValue ?? "", position: .bottom)
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }

}

extension String{
    func replace_fromStart(str:String , endIndex:Int , With:String) -> String {
        var strReplaced = str ;
        let start = str.startIndex;
        let end = str.index(str.startIndex, offsetBy: endIndex);
        strReplaced = str.replacingCharacters(in: start..<end, with: With) ;
        return strReplaced;
    }
}

extension OTPVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.getOtpAPI()
        }
        else {
           // self.showNoIntAlert()
        }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
