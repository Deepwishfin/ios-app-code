//
//  DashboardVC.swift
//  Tutorial
//
//  Created by Wishfin on 10/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SkyFloatingLabelTextField
import SwiftyJSON
import SystemConfiguration

class DashboardVC: UIViewController,UIScrollViewDelegate {

    //MARK: IBOutlet
    @IBOutlet weak var dashboardScrView: UIScrollView!
    @IBOutlet weak var radioView: UIView!
    @IBOutlet weak var secQueDetailLabel: UILabel!
    @IBOutlet weak var creditFactorLabel: UILabel!
    @IBOutlet weak var creditFactorDetailLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var onTimePercentButton: UIButton!
    @IBOutlet weak var creditUtilizeButton: UIButton!
    @IBOutlet weak var credUtilDetailLabel: UILabel!
    @IBOutlet weak var onTimeDetailLabel: UILabel!
    @IBOutlet weak var creditNeedAttenButton: UIButton!
    @IBOutlet weak var ontimeNeedAttenButton: UIButton!
    @IBOutlet weak var hardEnqNeedAttenButton: UIButton!
    @IBOutlet weak var hardEnqDetailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cibilScoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var securityQue1View: UIView!
    @IBOutlet weak var technicalErrorView: TechnicalErrorView!
    @IBOutlet weak var techErrorView: UIView!
    @IBOutlet weak var updateInfoView: UpdateInfoView!
    @IBOutlet weak var applyCCView: ApplyCCView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailtextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emptyEmailView: UIView!
    
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var refreshLbl: UILabel!
    
    
    //MARK: Variables
    let kHeaderSectionTag: Int = 6900;
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionNames: Array<Any> = []
    var queKeyArray: Array<Any> = []
    var queArray = [QueModel]()
    var ansArray = [AnsModel]()
    var indexArray = [IndexPath]()
    var radioArray = [Bool]()
    let gradView = GradientRingProgressView()
    var model = LoginModel()
    var nextApiCall = ""
    var isRetruningCustomer = ""
    var cibilScore = ""
    var cibilId = ""
    var lastFtechDate = ""
    var cibilStatus = ""
    var message = ""
    var lastMonthInquiryCount = 0
    var last6MonthInquiryCount = 0
    var question_key = ""
    var answer_key = ""
    var singleQue = false
    var isTabHide = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print(" - - - - - - - - ",Defaults.getHeader())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /// Setting View
    func setupView(){
        self.view.isUserInteractionEnabled = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        // add notification observers
        self.techErrorView.isHidden = true
        self.technicalErrorView.isHidden = true
        setDashboardRefresh()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: mobileTextField.frame.height))
        mobileTextField.leftView = paddingView
        mobileTextField.leftViewMode = .always
        self.tableView!.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: DescriptionCell.className(), bundle: nil), forCellReuseIdentifier: DescriptionCell.className())
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableView.automaticDimension
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height))
        emailtextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mobileTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.resendButton.setCornerRadiusOfView(cornerRadiusValue: 5)
        self.mobileTextField.setCornerRadiusOfView(cornerRadiusValue: 5)
        self.submitButton.setCornerRadiusOfView(cornerRadiusValue: 5)
        self.technicalErrorView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        self.bottomView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        self.refreshBtn.setCornerRadiusOfView(cornerRadiusValue: 5)
        self.refreshBtn.isUserInteractionEnabled = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.updateInfoView.updateButton.addTarget(self, action: #selector(updateInfoClicked), for: .touchUpInside)
        self.applyCCView.getCCButton.addTarget(self, action: #selector(getCCBtnClicked), for: .touchUpInside)
        self.applyCCView.logoutButton.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
        self.technicalErrorView.okButton.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
        self.technicalErrorView.logoutButton.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
        gradView.frame = circleView.bounds.insetBy(dx:0, dy: 0)
        circleView.addSubview(gradView)
        gradView.progress = 0.65
        circleView.isHidden = true
        bottomView.isHidden = true
        creditFactorLabel.isHidden = true
        creditFactorDetailLabel.isHidden = true
        refreshLbl.text = ""
        guard let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails) else {
            return
        }
        guard let loginModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel else {
            return
        }
        model = loginModel
        nameLabel.text = "Hello \(model.first_name)"
        let timeOfDay = Calendar.current.component(.hour, from: Date())
        if (timeOfDay >= 0 && timeOfDay < 12) {
            messageLabel.text = "Good Morning, Here is your credit score"
        } else if (timeOfDay >= 12 && timeOfDay < 16) {
            messageLabel.text = "Good Afternoon, Here is your credit score"
        } else if (timeOfDay >= 16 && timeOfDay < 24) {
            messageLabel.text = "Good Evening, Here is your credit score"
        }
        setupForApi()
    }
    
    func setupForApi(){
        if let loginType:String = UserDefaults.standard.value(forKey: DefaultsKey.loginType) as? String{
            if loginType == "signup"{
                if let pancard = UserDefaults.standard.value(forKey: "pancard"){
                    model.pancard = pancard as! String
                }
                
                if let dob = UserDefaults.standard.value(forKey: "dob"){
                    model.date_of_birth = dob as! String
                }
                cibilFulfillOrderApi()
            }
            else if loginType == "login"{
                getDashboardTokenApi()
            }
        }
    }
    
    func setDashboardRefresh() {
        dashboardScrView.refreshControl = UIRefreshControl()
        dashboardScrView.refreshControl?.addTarget(self, action:#selector(refreshDashboard),for: .valueChanged)
    }

    @objc func refreshDashboard() {
        DispatchQueue.main.async {
            self.dashboardScrView.refreshControl?.endRefreshing()
        }
        setupForApi()
    }
    
    func hideTabBar() {
        isTabHide = true
        self.tabBarController?.setTabBarVisible(visible: false, animated: false)
    }
    
    func showTabBar() {
        isTabHide = false
        self.tabBarController?.setTabBarVisible(visible: true, animated: false)

    }
    
    @IBAction func emailSubmitClicked(_ sender: Any) {
        self.view.endEditing(true)
         if emailtextField.text!.isEmpty{
            emailtextField.errorMessage = AlertField.emptyEmailString
        }
        else if !isValidEmail(emailStr: emailtextField.text!){
            emailtextField.errorMessage = AlertField.invalidEmailString
        }
        else {
            emptyEmailView.isHidden = true
            model.email_id = emailtextField.text!
            self.cibilFulfillOrderApi()
        }
    }
    
    @IBAction func radioCancelClicked(_ sender: Any) {
        radioView.isHidden = true
    }
     
    @IBAction func radioSubmitClicked(_ sender: Any) {
        for value in self.radioArray{
            if value == false{
                self.showToast(messsage: "Please select all options.", position: .bottom)
                return
            }
        }
        radioView.isHidden = true
        cibilVerifyRadioAnsApi()
    }
    
    @objc func updateInfoClicked(){
        self.updateInfoView.isHidden = true
        self.showTabBar()
    }
    
    @objc func getCCBtnClicked() {
        guard let url = URL(string: "https://www.wishfin.com/credit-cards") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
  
    @objc func okBtnClicked() {
        self.techErrorView.isHidden = true
        self.technicalErrorView.isHidden = true
        cibilUserDetailApi()
    }
    
    @objc func logoutBtnClicked() {
        showLogoutAlert()
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "YES",style: .default,handler: {(_: UIAlertAction!) in
            //Sign out action
            Defaults.resetData()
            Defaults.setSession(false)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let loginViewController = LoginVC.init(nibName: LoginVC.className(), bundle: nil)
            let navigationController = UINavigationController(rootViewController: loginViewController)
            appDelegate.window?.rootViewController = navigationController
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func historyBtnClicked(_ sender: Any) {
        let hisObj = HistoryVC.init(nibName: HistoryVC.className(), bundle: nil)
        hisObj.mobileNo = model.mobile_number
        hisObj.cibilScore = self.cibilScore
        hisObj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hisObj, animated: true)
    }
    
    @IBAction func ontimeBtnClicked(_ sender: Any) {
        let ontimeObj = OneTimePaymentVC.init(nibName: OneTimePaymentVC.className(), bundle: nil)
        ontimeObj.cibilId = self.cibilId
        ontimeObj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ontimeObj, animated: true)
    }
    
    @IBAction func creditUtilizationBtnClicked(_ sender: Any) {
        let credObj = CreditUtilizationVC.init(nibName: CreditUtilizationVC.className(), bundle: nil)
        credObj.hidesBottomBarWhenPushed = true
        credObj.cibilId = self.cibilId
        self.navigationController?.pushViewController(credObj, animated: true)
    }
    
    @IBAction func hardEnqBtnClicked(_ sender: Any) {
        let hardEnqObj = HardEnquireVC.init(nibName: HardEnquireVC.className(), bundle: nil)
        hardEnqObj.hidesBottomBarWhenPushed = true
        hardEnqObj.cibilId = self.cibilId
        hardEnqObj.lastMonthInquiryCount = lastMonthInquiryCount
        hardEnqObj.last6MonthInquiryCount = last6MonthInquiryCount
        self.navigationController?.pushViewController(hardEnqObj, animated: true)
    }
    
    @IBAction func resendBtnClicked(_ sender: Any) {
        self.securityQue1View.isHidden = true
        self.view.endEditing(true)
        cibilVerifyAnsApi(isResend: true)
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.securityQue1View.isHidden = true
        self.view.endEditing(true)
        if mobileTextField.text!.isEmpty{
            mobileTextField.errorMessage = AlertField.digitMobileString
        }
        else if !isMobileNumberValid(mobileNumberData: mobileTextField.text!) {
            mobileTextField.errorMessage = AlertField.validMobileString
        }
        else {
            cibilVerifyAnsApi(isResend: false)
        }
    }

    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield.tag == 111 {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if !isValidEmail(emailStr: emailtextField.text!){
                    floatingLabelTextField.errorMessage = AlertField.invalidEmailString
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        else {
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
    }
     
    
    @IBAction func PersonalLoanClicked(_ sender: Any) {
         
        let vc = UIStoryboard.init(name: "PersonalLoan", bundle: Bundle.main).instantiateViewController(withIdentifier: "PersonalLoanVC") as? PersonalLoanVC
        vc?.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        
//        let vc = UIStoryboard.init(name: "PersonalLoan", bundle: Bundle.main).instantiateViewController(withIdentifier: "BanksQuotesVC") as? BanksQuotesVC
//        vc?.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    @IBAction func myProfileClicked(_ sender: Any) {
        let obj = ProfileVC.init(nibName: ProfileVC.className(), bundle: nil)
                obj.hidesBottomBarWhenPushed = true 
                self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func RefreshBtnClicked(_ sender: Any) {
        self.cibilCustomerAssetApi(isRefreshed: true)
    }
    
    
    func chekDateAndRefresh(dateChk: Date) {
        
//        var dayComponenet = DateComponents()
//        dayComponenet.day = 30
//
//        let theCalendar = NSCalendar.current
//        guard let nextDate = theCalendar.date(byAdding: dayComponenet, to: dateChk) else { return }
        
         
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMM yyyy"
         
        let dateNew = dateFormatterGet.string(from: Date())
        let dateNow = dateFormatterGet.date(from: dateNew)
        
//        print(dateChk , dateNow)
        
        let diffInDays = Calendar.current.dateComponents([.day], from: dateChk, to: dateNow ?? Date()).day
        
//        print(diffInDays)
        
        if diffInDays ?? 32 < 31 {
            
            var cuntVal = 31 - diffInDays!
             
            let calendar = Calendar.current
            let day1 = calendar.component(.day, from: dateChk)
            let day2 = calendar.component(.day, from: dateNow ?? Date())
            
            if day1 != day2 && cuntVal == 31 {
                cuntVal -= 1
            }
            
            
            self.refreshLbl.text = "Next score update will be in \(cuntVal) Days"
            self.refreshBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.refreshBtn.isUserInteractionEnabled = false
        } else {
            self.refreshLbl.text = "Click \"Refresh\" to see your updated score"
            self.refreshBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.refreshBtn.isUserInteractionEnabled = true
        }
    }
    
    
    
}

//MARK: Get Api call
extension DashboardVC {
    func getCibilFactorApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.getDashboardCibitFactor
            let secondUrl = self.cibilId
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                    let userInfoDic =  resultDic["userInfo"]
                        UserDefaults.standard.set(userInfoDic["cibil_score"].stringValue, forKey: DefaultsKey.cibilScore)
                        self.last6MonthInquiryCount = resultDic["last6MonthInquiryCount"].intValue
                        self.lastMonthInquiryCount =  resultDic["lastMonthInquiryCount"].intValue
                        self.hardEnqDetailLabel.text = "\(self.lastMonthInquiryCount) last month enquiries"
                        if (self.lastMonthInquiryCount > 2){
                                self.hardEnqDetailLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                self.hardEnqNeedAttenButton.isHidden = false
                            }
                        
                        let creditUtiliseDic =  resultDic["creditUtilize"].dictionaryValue
                        if !creditUtiliseDic.isEmpty {
                            if let creditUtilvalue = creditUtiliseDic["credit_utilize"]?.stringValue{
                                if creditUtilvalue.isEmpty{
                                    self.credUtilDetailLabel.text = "0% Utilized"
                                }
                                else{
                                    self.credUtilDetailLabel.text = "\(creditUtilvalue)% Utilized"
                                }
                            }
                            self.creditUtilizeButton.isEnabled = true
                        }
                        else {
                            self.credUtilDetailLabel.text = "NA"
                            self.creditUtilizeButton.isEnabled = false
                        }
                        if let credUtCount:Int = Int(creditUtiliseDic["credit_utilize"]?.stringValue ?? "0"){
                            if (credUtCount > 65){
                                self.credUtilDetailLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                self.creditNeedAttenButton.isHidden = false
                            }
                        }
                        

                        let onTimePaymentPercent =  resultDic["onTimePaymentPercentile"].intValue
                        self.onTimeDetailLabel.text = "\(onTimePaymentPercent)% payments are on time"
                            if (onTimePaymentPercent < 60){
                                self.onTimeDetailLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                self.ontimeNeedAttenButton.isHidden = false
                            }
                        
                        if onTimePaymentPercent == 0{
                            self.onTimePercentButton.isEnabled = false
                        }
                        else {
                            self.onTimePercentButton.isEnabled = true
                        }
                        self.cibilScore = userInfoDic["cibil_score"].stringValue
                        self.cibilId = userInfoDic["cibil_id"].stringValue
                        self.lastFtechDate = userInfoDic["cibil_score_fetch_date"].stringValue
                        UserDefaults.standard.set(self.cibilId, forKey: DefaultsKey.cibilId)
                        UserDefaults.standard.set(self.cibilScore, forKey: DefaultsKey.cibilScore)
                        self.cibilScoreLabel.text = self.cibilScore
                        self.gradView.progress = CGFloat(Float(self.cibilScore) ?? 0.0/900.0)
                        self.circleView.isHidden = false
                        self.bottomView.isHidden = false
                        self.creditFactorLabel.isHidden = false
                        self.creditFactorDetailLabel.isHidden = false
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let datePrint = DateFormatter()
                        datePrint.dateFormat = "dd MMM yyyy"
                        if let date = dateFormatterGet.date(from: self.lastFtechDate) {
                            self.dateLabel.text = "Last updated on \(datePrint.string(from: date))"
                            UserDefaults.standard.set(datePrint.string(from: date), forKey: DefaultsKey.fetchDate)
                            self.chekDateAndRefresh(dateChk: date)
                        }
                    }
                    
                    self.cardsApi()
                }
                else {
                    self.creditFactorLabel.isHidden = true
                    self.creditFactorDetailLabel.isHidden = true
                    self.bottomView.isHidden = true
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }
}

//MARK: Get Api call
extension DashboardVC {
    /// Api call for getting token
    func getDashboardTokenApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            let url : String = UrlName.baseUrl + UrlName.oAuth
            //Live
            let params = ["username":"wfexpenseapp","password": "8aNKX7vDu758R6Vu","client_id": "wfexpenseapp","grant_type": "password"]
            // Stage
//            let params = ["username":"wishfin","password": "qwer1234","client_id": "wishfin","grant_type": "password"]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: [:], url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                self.updateLastLogApi()
                if let accessToken = jsonValue[DefaultsKey.accessToken]?.stringValue{
                    Defaults.setAccessToken(accessToken)
                } else {
                    return
                }
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    
    
    /// Api for update last login
    func updateLastLogApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let getOtpURL : String = UrlName.baseUrl + UrlName.updateLastLogin
            var master_user_id = ""
            if let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails),
                let model = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel {
                master_user_id = model.master_user_id
            }
            let params = ["master_user_id":master_user_id] as [String : Any]
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getOtpURL, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.cibilUserDetailApi()
                    return
                }
                print(jsonValue)
                self.cibilUserDetailApi()
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cibilFulfillOrderApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let url = UrlName.baseUrl + UrlName.cibilFulfillOrder
            let headers = ["Authorization": Defaults.getHeader()]
            
            let params = [
                "first_name":model.first_name,
                "middle_name":model.middle_name,
                "last_name":model.last_name,
                "pancard":model.pancard,
                "date_of_birth":model.date_of_birth,
                "mobile_number":model.mobile_number,
                "email_id":model.email_id,
                "gender":"1",
                "city_name":"Default",
                "state_code":"27",
                "residence_address":"Default",
                "residence_pincode":"400001",
                "legal_response":"Accept",
                "report_trigger":"true",
                "show_report_xml":"false",
                "consent_option":"",
                "website_flag":"wishfin",
                "source": "Wishfin_iOS",
                "resource_pagename": "Cibil_Wishfin_iOS",
                "resource_source": "Cibil_Wishfin_iOS",
                "resource_querystring": "",
                "resource_ip_address": getIPAddress(),
                "utm_source": "",
                "utm_medium": "",
                "referrer_address": "Wishfin_iOS",
                "querystring": ""
                ] as [String : Any]
            print("fullfill order Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.techErrorView.isHidden = false
                    self.technicalErrorView.isHidden = false
                    return
                }
                print(jsonValue)
                self.dismissHUD(isAnimated: true)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                                
                            self.nextApiCall = resultDic["next_api_call"].stringValue
                            self.cibilStatus = resultDic["cibil_status"].stringValue
                            self.isRetruningCustomer = resultDic["is_returning_customer"].stringValue
                            self.cibilScore = resultDic["cibil_score"].stringValue
                            self.cibilId = resultDic["cibil_id"].stringValue
                            self.lastFtechDate = resultDic["cibil_score_fetch_date"].stringValue
                            self.message = resultDic["message"].stringValue
                            
                            if self.cibilStatus == "Failure"{
                                self.techErrorView.isHidden = false
                                self.technicalErrorView.isHidden = false
                            }
                             if (((self.cibilStatus == "InProgress" && self.nextApiCall == "cibil-authentication-questions") && self.isRetruningCustomer == "1") || ((self.cibilStatus == "Pending" && self.nextApiCall == "cibil-authentication-questions")  && self.isRetruningCustomer == "1")){
                                //Aunthenticate question  api call
                                self.cibilAuthQueApi()
                        }
                        
                           else if self.isRetruningCustomer == "1"{
                                self.showToast(messsage: "User already exist", position: .bottom)
                                return
                            }
                            else if ((self.cibilStatus == "success" || self.cibilStatus == "Success") && self.nextApiCall == "cibil-customer-assets"){
                                //customer asset api call
                                self.cibilCustomerAssetApi(isRefreshed: false)
                            }
                            else if ((self.cibilStatus == "InProgress" && self.nextApiCall == "cibil-authentication-questions") || (self.cibilStatus == "Pending" && self.nextApiCall == "cibil-authentication-questions")){
                                //Aunthenticate question  api call
                                self.cibilAuthQueApi()
                            }
                            else if (self.cibilStatus == "failed"){
                                self.showToast(messsage: self.message, position: .bottom)
                                return
                            }
                            else {
                                if (self.cibilScore == "0" || self.cibilScore == "1") {
                                    //Apply credit card dialoge box
                                    self.applyCCView.isHidden = false
                                    self.hideTabBar()
                                }
                                else if (self.cibilId.isEmpty || self.cibilScore == "-1"){
                                    //update detail dialouge
                                    self.techErrorView.isHidden = false
                                    self.technicalErrorView.isHidden = false
                                    //self.updateInfoView.isHidden = false
                                    self.hideTabBar()
                                }
                                else {
                                    UserDefaults.standard.set(self.cibilId, forKey: DefaultsKey.cibilId)
                                    UserDefaults.standard.set(self.cibilScore, forKey: DefaultsKey.cibilScore)
                                    self.cibilScoreLabel.text = self.cibilScore
                                    self.gradView.progress = CGFloat(Float(self.cibilScore) ?? 0.0/900.0)
                                    self.circleView.isHidden = false
                                    self.bottomView.isHidden = false
                                    self.creditFactorLabel.isHidden = false
                                    self.creditFactorDetailLabel.isHidden = false
                                    let dateFormatterGet = DateFormatter()
                                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let datePrint = DateFormatter()
                                    datePrint.dateFormat = "dd MMM yyyy"
                                    if let date = dateFormatterGet.date(from: self.lastFtechDate) {
                                        self.dateLabel.text = "Last updated on \(datePrint.string(from: date))"
                                        UserDefaults.standard.set(datePrint.string(from: date), forKey: DefaultsKey.fetchDate)
                                        self.getCibilFactorApi()
                                        self.chekDateAndRefresh(dateChk: date)

                                    }
                                }
                            }
                    }
                }
                else if jsonValue["status"] == "failed" {
                    self.techErrorView.isHidden = false
                    self.technicalErrorView.isHidden = false
                }
                else if jsonValue["status"] == 422 {
                    self.emptyEmailView.isHidden = true
                }
                self.view.isUserInteractionEnabled = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true

            })
        } else {
            self.showNoIntAlert()
        }
    }
    
    func cibilUserDetailApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.getCibilUserDetail
            masterUserId = model.master_user_id
            mfUserId = model.mf_user_id
            let secondUrl = "master_user_id=\(model.master_user_id)&mf_user_id=\(model.mf_user_id)"
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , getUrl)

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                self.dismissHUD(isAnimated: true)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                   //     UtilityClass.saveUserInfoData(userDict: resultDic.dictionary!)
                    //    UserProfileCache.save(jsonValue["result"])
                                            
                        self.cibilScore = resultDic["cibil_score"].stringValue
                        self.cibilId = resultDic["cibil_id"].stringValue
                        self.lastFtechDate = resultDic["cibil_score_fetch_date"].stringValue
                        if (self.cibilScore == "0" || self.cibilScore == "1") {
                            self.hideTabBar()
                            self.applyCCView.isHidden = false
                            //Apply credit card dialoge box
                        }
                        else if (self.cibilId.isEmpty || self.cibilScore == "-1"){
                            // update info dialoge
//                            self.hideTabBar()
//                            self.techErrorView.isHidden = false
//                            self.technicalErrorView.isHidden = false
                            //self.updateInfoView.isHidden = false
                            self.cibilFulfillOrderApi()
                        }
                        else {
                                      
                            UserDefaults.standard.set(self.cibilId, forKey: DefaultsKey.cibilId)
                            
                            UserDefaults.standard.set(self.cibilScore, forKey: DefaultsKey.cibilScore)
                            self.cibilScoreLabel.text = self.cibilScore
                            self.gradView.progress = CGFloat(Float(self.cibilScore) ?? 0.0/900.0)
                            self.circleView.isHidden = false
                            self.bottomView.isHidden = false
                            self.creditFactorLabel.isHidden = false
                            self.creditFactorDetailLabel.isHidden = false
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let datePrint = DateFormatter()
                            datePrint.dateFormat = "dd MMM yyyy"
                            if let date = dateFormatterGet.date(from: self.lastFtechDate) {
                                self.dateLabel.text = "Last updated on \(datePrint.string(from: date))"
                                UserDefaults.standard.set(datePrint.string(from: date), forKey: DefaultsKey.fetchDate)
                                self.chekDateAndRefresh(dateChk: date)
                            }
                            self.getCibilFactorApi()
                        }
                    }
                }
                else if jsonValue["status"] == "failed" {
                    self.cibilFulfillOrderApi()
                }
                self.view.isUserInteractionEnabled = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cibilAuthQueApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.cibilAuthQue
            let secondUrl = self.cibilId
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                self.dismissHUD(isAnimated: true)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        self.nextApiCall = resultDic["next_api_call"].stringValue
                        self.cibilStatus = resultDic["cibil_status"].stringValue
                        if ((self.cibilStatus == "success" || self.cibilStatus == "Success") && self.nextApiCall == "cibil-customer-assets"){
                            //customer asset api call
                            self.cibilCustomerAssetApi(isRefreshed: false)
                        }
                        else if ((self.cibilStatus == "InProgress" || self.cibilStatus == "Pending") && self.nextApiCall == "cibil-verify-answers"){
                            self.singleQue = true
                            let queDic = resultDic["questions"]
                            let ansDic = queDic["AnswerChoice"]
                            let key = ansDic["Key"].stringValue
                            if key == "USER_TO_INPUT_ANSWER"{
                                self.securityQue1View.isHidden = false
                                self.question_key = queDic["Key"].stringValue
                                let ansDic = queDic["AnswerChoice"]
                                self.secQueDetailLabel.text = ansDic["AnswerChoiceText"].stringValue
                                self.answer_key = ansDic["AnswerChoiceId"].stringValue
                            }
                            else {
                                let responseArray = resultDic["questions"].arrayValue
                                if responseArray.count > 0{
                                    self.queArray.removeAll()
                                    for model in responseArray{
                                        self.queArray.append(QueModel(json: model))
                                    }
                                    for model in self.queArray{
                                        self.sectionNames.append(model.FullQuestionText)
                                        self.queKeyArray.append(model.Key)
                                        let indexPth = IndexPath(row: -1, section: -1)
                                        self.radioArray.append(false)
                                        self.indexArray.append(indexPth)
                                    }
                                    self.tableView.reloadData()
                                }
                                self.radioView.isHidden = false
                            }
                        }

                    }
                }
                self.view.isUserInteractionEnabled = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true

            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cibilVerifyRadioAnsApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let url : String = UrlName.baseUrl + UrlName.cibilVerifyAns
            
            var ansParamArray = [Dictionary<String, Any>]()
            for i in 0..<sectionNames.count {
                let indexPath = indexArray[i]
                let ansArray = self.queArray[i].ansArray
                let model = ansArray[indexPath.row]
                let dict = [
                    "answer_key": model.AnswerChoiceId,
                    "question_key": self.queKeyArray[i] as? String ?? "",
                    "user_input_answer": model.AnswerChoiceText,
                    "skip":"false"
                    ] as [String : Any]
                ansParamArray.append(dict)
                print(i)
            }
            var params:[String : Any] = [:]
            params = ["cibil_id":self.cibilId,"answers": ansParamArray] as [String : Any]
            print(params)
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        self.nextApiCall = resultDic["next_api_call"].stringValue
                        self.cibilStatus = resultDic["cibil_status"].stringValue
                        if ((self.cibilStatus == "success" || self.cibilStatus == "Success") && self.nextApiCall == "cibil-customer-assets"){
                            //customer asset api call
                            self.cibilCustomerAssetApi(isRefreshed: false)
                        }
                        else if (self.cibilStatus == "Failure"){
                            self.technicalErrorView.isHidden = false
                            self.techErrorView.isHidden = false
                        }
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cibilVerifyAnsApi(isResend:Bool) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let url : String = UrlName.baseUrl + UrlName.cibilVerifyAns
            var params:[String : Any] = [:]
            if isResend {
                params = ["cibil_id":self.cibilId,
                          "answers": [
                            [
                            "question_key":self.question_key,
                             "answer_key":self.answer_key,
                             "user_input_answer":"",
                             "resend":"true"
                            ]
                    ]
                    ] as [String : Any]
            }
            else {
                params = ["cibil_id":self.cibilId,
                          "answers": [
                            [
                                "question_key":self.question_key,
                                "answer_key":self.answer_key,
                                "user_input_answer":mobileTextField.text!,
                                "skip":"false"
                            ]
                    ]
                    ] as [String : Any]
            }
            
            
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        self.nextApiCall = resultDic["next_api_call"].stringValue
                        self.cibilStatus = resultDic["cibil_status"].stringValue
                         if ((self.cibilStatus == "success" || self.cibilStatus == "Success") && self.nextApiCall == "cibil-customer-assets"){
                            //customer asset api call
                            self.cibilCustomerAssetApi(isRefreshed: false)
                        }
                        else if ((self.cibilStatus == "InProgress" && self.nextApiCall == "cibil-authentication-questions") || (self.cibilStatus == "Pending" && self.nextApiCall == "cibil-authentication-questions")){
                            //Aunthenticate question  api call
                            // radio button question popup
                            self.cibilAuthQueApi()
                        }

                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cibilCustomerAssetApi(isRefreshed:Bool) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: AlertField.loaderString)
            let url : String = UrlName.baseUrl + UrlName.cibilCustomerAsset
            var params = ["cibil_id":self.cibilId,
                          "show_report_xml":true
                ] as [String : Any]
            
            if isRefreshed {
                params = ["cibil_id":self.cibilId,
                              "show_report_xml":false,
                              "fetch_from_cibil":true,
                              "is_autofetch":true
                    ] as [String : Any]
            }
            
             
            let headers = ["Authorization": Defaults.getHeader()]
            print("Parameters:" , params)
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: url, method: .post, parameters: params, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    if let resultDic = jsonValue["result"] {
                        self.cibilScore = resultDic["cibil_score"].stringValue
                        self.cibilId = resultDic["cibil_id"].stringValue
                        self.lastFtechDate = resultDic["cibil_score_fetch_date"].stringValue
                        self.message = resultDic["message"].stringValue
                            if (self.cibilScore == "0" || self.cibilScore == "1") {
                                //Apply credit card dialoge box
                                self.applyCCView.isHidden = false
                                self.hideTabBar()
                            }
                            else if (self.cibilId.isEmpty || self.cibilScore == "-1"){
                                //update detail dialouge
                                self.techErrorView.isHidden = false
                                self.technicalErrorView.isHidden = false
                                //self.updateInfoView.isHidden = false
                                self.hideTabBar()
                            }
                            else {
                                UserDefaults.standard.set(self.cibilId, forKey: DefaultsKey.cibilId)
                                UserDefaults.standard.set(self.cibilScore, forKey: DefaultsKey.cibilScore)
                                self.cibilScoreLabel.text = self.cibilScore
                                self.gradView.progress = CGFloat(Float(self.cibilScore) ?? 0.0/900.0)
                                self.circleView.isHidden = false
                                self.bottomView.isHidden = false
                                self.creditFactorLabel.isHidden = false
                                self.creditFactorDetailLabel.isHidden = false
                                let dateFormatterGet = DateFormatter()
                                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let datePrint = DateFormatter()
                                datePrint.dateFormat = "dd MMM yyyy"
                                if let date = dateFormatterGet.date(from: self.lastFtechDate) {
                                    self.dateLabel.text = "Last updated on \(datePrint.string(from: date))"
                                    UserDefaults.standard.set(datePrint.string(from: date), forKey: DefaultsKey.fetchDate)
                                    if !isRefreshed {
                                        self.getCibilFactorApi()
                                    }
                                    
                                    self.chekDateAndRefresh(dateChk: date)
                                }
                            }
                        
                    }
                }
                else  {
                    if let msgDic = jsonValue["message"]{
                        self.showToast(messsage: msgDic["cibil_no_success"].stringValue, position: .bottom)

                    }
                    
                }
                self.dismissHUD(isAnimated: true)
                self.view.isUserInteractionEnabled = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
            })
        }else{
            self.showNoIntAlert()
        }
    }
}

extension DashboardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 111{
            return true
        }
        else {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }
}



// MARK: - Tableview Methods
extension DashboardVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return self.queArray[section].ansArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.className(), for: indexPath) as! DescriptionCell
        let ansArray = self.queArray[indexPath.section].ansArray
        let model = ansArray[indexPath.row]
        let index = self.indexArray[indexPath.section]
        cell.setupCellUI(model: model)
        if indexPath.row == index.row{
                self.radioArray[indexPath.section] = true
                cell.radioImg.image = UIImage(named: "radio")
            }
            else {
                cell.radioImg.image = UIImage(named: "radioblank")
            }
        cell.contentView.backgroundColor = CommonMethods.hexStringToUIColor(hex: "ffffff")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexArray[indexPath.section] = indexPath
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        if (section % 2 == 0){
            header.textLabel?.textColor =  CommonMethods.hexStringToUIColor(hex: "304258")

            header.contentView.backgroundColor = CommonMethods.hexStringToUIColor(hex: "d3d3d3")
        }
        else {
            header.textLabel?.textColor = UIColor.white

            header.contentView.backgroundColor = CommonMethods.hexStringToUIColor(hex: "107A66")
        }
        
        header.textLabel?.numberOfLines = 2
        header.textLabel?.font = UIFont(name: "Poppins-Regular", size: 18)!
        header.textLabel?.adjustsFontSizeToFitWidth = true
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(DashboardVC.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    // MARK: - Expand / Collapse Methods
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        self.expandedSectionHeaderNumber = -1;
        UIView.animate(withDuration: 0.4, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
        })
        var indexesPath = [IndexPath]()
        for i in 0 ..< self.sectionNames.count {
            let index = IndexPath(row: i, section: section)
            indexesPath.append(index)
        }
        self.tableView!.beginUpdates()
        self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
        self.tableView!.endUpdates()
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        UIView.animate(withDuration: 0.4, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        })
        var indexesPath = [IndexPath]()
        for i in 0 ..< self.sectionNames.count {
            let index = IndexPath(row: i, section: section)
            indexesPath.append(index)
        }
        self.expandedSectionHeaderNumber = section
        self.tableView!.beginUpdates()
        self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
        self.tableView!.endUpdates()
    }
}

extension DashboardVC {
    func parseJson(){
        if let path = Bundle.main.path(forResource: "que", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try? JSON(data: jsonData)
                let jsonValue = json?.dictionaryValue
                if jsonValue?["status"] == "success" {
                    if let resultDic = jsonValue?["result"] {
                        let responseArray = resultDic["questions"].arrayValue
                        if responseArray.count > 0{
                            self.radioView.isHidden = false
                            self.queArray.removeAll()
                            for model in responseArray{
                                self.queArray.append(QueModel(json: model))
                            }
                            for model in self.queArray{
                                self.sectionNames.append(model.FullQuestionText)
                                self.queKeyArray.append(model.Key)
                                let indexPth = IndexPath(row: -1, section: -1)
                                self.radioArray.append(false)
                                self.indexArray.append(indexPth)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

extension DashboardVC {
    func showNoIntAlert() {
        DispatchQueue.main.async {
            self.dashboardScrView.refreshControl?.endRefreshing()
        }
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.setupForApi()
            }
            else {
               // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITabBarController {

    private struct AssociatedKeys {
        // Declare a global var to produce a unique address as the assoc object handle
        static var orgFrameView:     UInt8 = 0
        static var movedFrameView:   UInt8 = 1
    }

    var orgFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.orgFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.orgFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var movedFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.movedFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.movedFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let movedFrameView = movedFrameView {
            view.frame = movedFrameView
        }
    }

    func setTabBarVisible(visible:Bool, animated:Bool) {
        //since iOS11 we have to set the background colour to the bar color it seams the navbar seams to get smaller during animation; this visually hides the top empty space...
        view.backgroundColor =  self.tabBar.barTintColor
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }

        //we should show it
        if visible {
            tabBar.isHidden = false
            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                //restore form or frames
                self.view.frame = self.orgFrameView!
                //errase the stored locations so that...
                self.orgFrameView = nil
                self.movedFrameView = nil
                //...the layoutIfNeeded() does not move them again!
                self.view.layoutIfNeeded()
            }
        }
            //we should hide it
        else {
            //safe org positions
            orgFrameView   = view.frame
            // get a frame calculation ready
            let offsetY = self.tabBar.frame.size.height
            movedFrameView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            //animate
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.view.frame = self.movedFrameView!
                self.view.layoutIfNeeded()
            }) {
                (_) in
                self.tabBar.isHidden = true
            }
        }
    }

    func tabBarIsVisible() ->Bool {
        return orgFrameView == nil
    }
}



//MARK: Get Api call
extension DashboardVC {
    func cardsApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
            let firstUrl = UrlName.baseUrl + UrlName.getCibitFactor
            let secondUrl = "cibil_id=\(cibilId)&type=\(UrlName.creditUtilse)"
            let getUrl = firstUrl + secondUrl
            print("getCibitFactor - - - - - - ",getUrl)
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    
                     
                      if let resultDic = jsonValue["result"] {
                        
                        let responseArray =  resultDic["creditUtilizeAccountWise"].arrayValue
                          
                        
                        
                        if responseArray.count > 0 {
                            var creditUtiliseArray = [CreditUtiliseModel]()
                            for country in responseArray{
                                creditUtiliseArray.append(CreditUtiliseModel(json: country))
                            }
                            
                            cardListArrayAbhi.removeAll()
                            cardListArrayAbhi = creditUtiliseArray
                            
                            var myArr:[[String:String]] = []
                            
                            
                            for item in 0..<cardListArrayAbhi.count {
                                
                                let cardCode = cardListArrayAbhi[item].account_number
                                var card_name_code = ""
                                var card_network_code = ""
                                
                                if !cardListArrayAbhi[item].cart_status.isEmpty {
                                    Defaults.setCardUnlock(true)
                                    
                                    let cardStatus = cardListArrayAbhi[item].cart_status
                                     
                                    card_name_code = "".removeOptional(myStr: "\(String(describing: cardStatus["card_name_code"]))")
                                    card_network_code = "".removeOptional(myStr: "\(String(describing: cardStatus["card_network_code"]))")
                                }
                                
                                let cardDic = ["cardCode": cardCode,
                                               "card_name_code": card_name_code,
                                               "card_network_code": card_network_code]
                                myArr.append(cardDic)
                            }
                            let chkmyArr = Defaults.getCardListAbhi()
                            if chkmyArr.count <= 0 {
                                Defaults.setCardListAbhi(myArr)
                            }
                           
 
                        }
                    }
                }
                
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
}

