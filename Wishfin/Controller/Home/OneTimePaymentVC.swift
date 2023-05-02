
//
//  OneTimePaymentVC.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit
import UICircularProgressRing

class OneTimePaymentVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var missedLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var oneTimeTableView: UITableView!
    @IBOutlet weak var onTimePayLabel: UILabel!
    @IBOutlet weak var totalPayLabel: UILabel!
    @IBOutlet weak var progress: UICircularProgressRing!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    
    //MARK: - Variables
    var onTimeArray = [OnTimePaymentModel]()
    var cibilId = ""
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    /// Setting up View
    func setupView(){
        setOnTimeRefresh()
        scrView.isHidden = true
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        oneTimePaymentApi()
        setUpTableView()
    }
    
    func setOnTimeRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshOnTime),for: .valueChanged)
    }
    
    @objc func refreshOnTime() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        oneTimePaymentApi()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.oneTimeTableView.register(UINib.init(nibName: OneTimePaymentCell.className(), bundle: nil), forCellReuseIdentifier: OneTimePaymentCell.className())
        self.oneTimeTableView.tableFooterView = UIView()
        
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UITableView Datasource
extension OneTimePaymentVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onTimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OneTimePaymentCell.className(), for: indexPath) as! OneTimePaymentCell
        cell.setupCellUIData(model: onTimeArray[indexPath.row])
        return cell
    }
    
    
}

// MARK: UITableView Delegate
extension OneTimePaymentVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = onTimeArray[indexPath.row]
        var isCredit = false
        if model.name == "Credit Card"{
            isCredit = true
        }
        else {
           isCredit = false
        }
        let obj = DetailsVC.init(nibName: DetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.account_id = model.account_id
        obj.isCredit = isCredit
//        obj.selectCard = []
        self.navigationController?.pushViewController(obj, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: Api call for get
extension OneTimePaymentVC{
    func oneTimePaymentApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.getCibitFactor
            let secondUrl = "cibil_id=\(cibilId)&type=\(UrlName.onTimePayment)"
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.showNoIntAlert()
                    self.dismissHUD(isAnimated: true)
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    self.scrView.isHidden = false
                    if let resultDic = jsonValue["result"] {
                        if let dic = resultDic["onTimePayment"].dictionary {
                            if let total_balance = dic["total_payment"]?.stringValue, let onTime = dic["ontime_payment"]?.stringValue{
                                self.totalPayLabel.text = total_balance
                                self.onTimePayLabel.text = onTime
                            }
                            if let totalPerComplete = dic["percentile"]?.stringValue{
                                if (Int(totalPerComplete) ?? 0 < 60){
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.headingLabel.text = "Need Attention"
                                }
                                else {
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                }
                            }
                            self.progress.value = CGFloat(dic["percentile"]?.doubleValue ?? 0)
                        }
                        
                        let responseArray =  resultDic["missPaymentAccount"].arrayValue
                        if responseArray.count > 0 {
                            self.onTimeArray.removeAll()
                            for country in responseArray{
                                self.onTimeArray.append(OnTimePaymentModel(json: country))
                            }
                            self.oneTimeTableView.reloadData()
                        }
                        if self.onTimeArray.count == 0{
                            self.missedLabel.isHidden = true
                            self.bottomHeight.constant = 0
                        }
                        else {
                            self.missedLabel.isHidden = false
                            let creditCount = self.onTimeArray.count
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

extension OneTimePaymentVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.oneTimePaymentApi()
            }
            else {
             //   self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
