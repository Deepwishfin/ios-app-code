//
//  CreditCardReportVC.swift
//  Wishfin
//
//  Created by Wishfin on 22/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CreditCardReportVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var credUtilLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var ccReportTableView: UITableView!
    @IBOutlet weak var totalBalLabel: UILabel!
    @IBOutlet weak var progress: UICircularProgressRing!
    @IBOutlet weak var creditLimitBalance: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var creditHeight: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    
    //MARK: - Variables
    var creditUtiliseArray = [CreditUtiliseModel]()
    
    @IBOutlet weak var Card_Height_Constraints: NSLayoutConstraint!
    
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Defaults.getCardUnlock() {
            Card_Height_Constraints.constant = 0.0
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        setupView()
    }
    
    /// Setting up View
    func setupView(){
        setCardsRefresh()
        scrView.isHidden = true
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        cardsApi()
        setUpTableView()
    }
    
    func setCardsRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshCard),for: .valueChanged)
    }
    
    @objc func refreshCard() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        cardsApi()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.ccReportTableView.register(UINib.init(nibName: CreditUtilCell.className(), bundle: nil), forCellReuseIdentifier: CreditUtilCell.className())
        self.ccReportTableView.tableFooterView = UIView()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unlockButtonClick(_ sender: Any) {
        
//        self.tabBarController?.selectedIndex = 3
        
        let obj = SelectCardViewController.init(nibName: SelectCardViewController.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.creditCardArray = creditUtiliseArray
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

// MARK: UITableView Datasource
extension CreditCardReportVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditUtiliseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreditUtilCell.className(), for: indexPath) as! CreditUtilCell
        cell.setupCellUIData(model: creditUtiliseArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView Delegate
extension CreditCardReportVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = creditUtiliseArray[indexPath.row]
    
        let obj = DetailsVC.init(nibName: DetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.account_id = model.account_id
        obj.isCredit = true
        if let rawFt_of_time = model.cart_status["card_name"] as? NSString {
            print(rawFt_of_time)
        }
        let cardName = model.cart_status as [String:Any]
        print(cardName["card_name"] ?? "")
        obj.str_CardCode = "\(cardName["card_name"] ?? "HYKfT8GMHf2UqSL5u7KT")" //cardName as! String
        obj.selectCard = [model]
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: Get Api call
extension CreditCardReportVC {
    func cardsApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
            let firstUrl = UrlName.baseUrl + UrlName.getCibitFactor
            let secondUrl = "cibil_id=\(cibilId)&type=\(UrlName.creditUtilse)"
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
                     
                    self.scrView.isHidden = false
                    if let resultDic = jsonValue["result"] {
                        
                        if let dic = resultDic["creditUtilize"].dictionary {
                            if let total_balance = dic["total_balance"]?.stringValue, let credLimit = dic["credit_limit"]?.stringValue{
                                let total = Int(total_balance) ?? 0
                                let cLimit = Int(credLimit) ?? 0
                                self.totalBalLabel.text = "₹\(String(describing: total.withCommas()))"
                                self.creditLimitBalance.text = "₹\(String(describing: cLimit.withCommas()))"
                            }
                            if let totalPerComplete = dic["credit_utilize"]?.stringValue{
                                if (Int(totalPerComplete) ?? 0 > 65){
                                    self.headingLabel.text = "Your utilization is pretty high"
                                    self.subHeadingLabel.text = "Get it under 65% to maintain a good credit score."
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                }
                                else {
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                }
                                self.progress.value = CGFloat(Double(totalPerComplete) ?? 0.0)
                                
                            }
                        }
                        
                        let responseArray =  resultDic["creditUtilizeAccountWise"].arrayValue
                        
                        if responseArray.count > 0 {
                            self.creditUtiliseArray.removeAll()
                            for country in responseArray{
                                self.creditUtiliseArray.append(CreditUtiliseModel(json: country))
                            }
                            self.ccReportTableView.reloadData()
                             
                        }
                        if self.creditUtiliseArray.count == 0{
                            self.credUtilLabel.isHidden = true
                            self.creditHeight.constant = 0
                        }
                        else {
                            self.credUtilLabel.isHidden = false
                            let creditCount = self.creditUtiliseArray.count
                            self.creditHeight.constant = CGFloat(70 * creditCount) + 20
                            self.creditView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
                        }
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}

extension CreditCardReportVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.cardsApi()
            }
            else {
               // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
