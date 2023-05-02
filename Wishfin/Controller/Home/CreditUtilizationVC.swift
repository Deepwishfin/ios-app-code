//
//  CreditUtilizationVC.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CreditUtilizationVC: UIViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var creditUtilisationLabel: UILabel!
    @IBOutlet weak var creditUtiTableView: UITableView!
    @IBOutlet weak var totalBalLabel: UILabel!
    @IBOutlet weak var progress: UICircularProgressRing!
    @IBOutlet weak var creditLimitBalance: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

    //MARK: - Variables
    var creditUtiliseArray = [CreditUtiliseModel]()
    var cibilId = ""
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    /// Setting up View
    func setupView(){
        setCredUtilRefresh()
        scrView.isHidden = true
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        creditUtiliseApi()
        setUpTableView()
    }
    
    func setCredUtilRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshCredUtil),for: .valueChanged)
    }
    
    @objc func refreshCredUtil() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        creditUtiliseApi()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.creditUtiTableView.register(UINib.init(nibName: CreditUtilCell.className(), bundle: nil), forCellReuseIdentifier: CreditUtilCell.className())
        self.creditUtiTableView.tableFooterView = UIView()
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: UITableView Datasource
extension CreditUtilizationVC : UITableViewDataSource {
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
extension CreditUtilizationVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = creditUtiliseArray[indexPath.row]
        let obj = DetailsVC.init(nibName: DetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.account_id = model.account_id
        obj.isCredit = true
        obj.str_CardCode = model.bank_code
        obj.selectCard = [creditUtiliseArray[indexPath.row]]
        self.navigationController?.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: Get Api call
extension CreditUtilizationVC {
    func creditUtiliseApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
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
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.headingLabel.text = "Your utilization is pretty high"
                                    self.subHeadingLabel.text = "Get it under 65% to maintain a good credit score."
                                }
                                else {
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")

                                }
                            }
                            self.progress.value = CGFloat(dic["credit_utilize"]?.doubleValue ?? 0)
                        }
                        let responseArray =  resultDic["creditUtilizeAccountWise"].arrayValue
                        if responseArray.count > 0 {
                            self.creditUtiliseArray.removeAll()
                            for country in responseArray{
                                self.creditUtiliseArray.append(CreditUtiliseModel(json: country))
                            }
                            self.creditUtiTableView.reloadData()
                        }
                        if self.creditUtiliseArray.count == 0{
                            self.creditUtilisationLabel.isHidden = true
                            self.bottomHeight.constant = 0
                        }
                        else {
                            self.creditUtilisationLabel.isHidden = false
                            let creditCount = self.creditUtiliseArray.count
                            self.bottomHeight.constant = CGFloat(70 * creditCount) + 20
                            self.bottomView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
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

extension CreditUtilizationVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.creditUtiliseApi()
            }
            else {
              //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
