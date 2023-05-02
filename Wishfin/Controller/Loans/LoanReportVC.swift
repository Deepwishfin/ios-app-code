//
//  LoanReportVC.swift
//  Wishfin
//
//  Created by Wishfin on 22/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import UICircularProgressRing

class LoanReportVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var secureTitleLabel: UILabel!
    @IBOutlet weak var secureDetailLabel: UILabel!
    @IBOutlet weak var unsecureTitleLabel: UILabel!
    @IBOutlet weak var unsecureDetailLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var secureView: UIView!
    @IBOutlet weak var unsecureView: UIView!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var secureTableView: UITableView!
    @IBOutlet weak var unsecureTableView: UITableView!
    @IBOutlet weak var unsecureLabel: UILabel!
    @IBOutlet weak var secureLabel: UILabel!
    @IBOutlet weak var progress: UICircularProgressRing!
    @IBOutlet weak var unsecureHeight: NSLayoutConstraint!
    @IBOutlet weak var secureHeight: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    
    //MARK:- Variables
    var secureArray = [SecureModel]()
    var unSecureArray = [SecureModel]()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        setupView()
    }
    
    
    /// Setting up View
    func setupView(){
        setLoanRefresh()
        setUpTableView()
        scrView.isHidden = true
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        loanApi()
    }
    
    func setLoanRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshLoan),for: .valueChanged)
    }
    
    @objc func refreshLoan() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        loanApi()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.secureTableView.register(UINib.init(nibName: SecureCell.className(), bundle: nil), forCellReuseIdentifier: SecureCell.className())
        self.unsecureTableView.register(UINib.init(nibName: UnSecureCell.className(), bundle: nil), forCellReuseIdentifier: UnSecureCell.className())
        self.secureTableView.tableFooterView = UIView()
        self.unsecureTableView.tableFooterView = UIView()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableView Datasource
extension LoanReportVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? secureArray.count : unSecureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SecureCell.className(), for: indexPath) as! SecureCell
            cell.setupCellUIData(model: secureArray[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UnSecureCell.className(), for: indexPath) as! UnSecureCell
            cell.setupCellUIData(model: unSecureArray[indexPath.row])
            return cell
        }
        
    }
}

// MARK: UITableView Delegate
extension LoanReportVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = tableView.tag == 0 ? secureArray[indexPath.row] : unSecureArray[indexPath.row]
        let obj = DetailsVC.init(nibName: DetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.account_id = model.account_id 
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: Get Api call
extension LoanReportVC {
    func loanApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
            let firstUrl = UrlName.baseUrl + UrlName.getCibitFactor
            let secondUrl = "cibil_id=\(cibilId)&type=\(UrlName.loan)"
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
                        if let dic = resultDic["creditMix"].dictionary {
                            if let secureLoan = dic["secured_loan"]?.stringValue, let unsecureLoan = dic["unsecured_loan"]?.stringValue{
                                self.secureLabel.text = secureLoan
                                self.unsecureLabel.text = unsecureLoan
                                if (secureLoan == "0" || secureLoan.isEmpty){
                                    self.secureTitleLabel.text = ""
                                    self.secureDetailLabel.text = ""
                                    self.secureHeight.constant = 0
                                    self.secureTitleLabel.isHidden = true
                                    self.secureDetailLabel.isHidden = true
                                }
                                if (unsecureLoan == "0" || unsecureLoan.isEmpty){
                                    self.unsecureTitleLabel.text = ""
                                    self.unsecureDetailLabel.text = ""
                                    self.unsecureHeight.constant = 0
                                    self.unsecureTitleLabel.isHidden = true
                                    self.unsecureDetailLabel.isHidden = true
                                }
                            }
                            if let totalPerComplete = dic["total_percent_completed"]?.stringValue{
                                if (Int(totalPerComplete) ?? 0 > 65){
                                    self.headingLabel.text = "Your utilization is pretty high"
                                    self.subHeadingLabel.text = "A high percentage of unsecured credit, affects your CIBIL score negatively."
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                                }
                                else {
                                    self.progress.innerRingColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                    self.progress.fontColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
                                    
                                }
                                
                            }
                            self.progress.value = CGFloat(dic["total_percent_completed"]?.doubleValue ?? 0)
                        }
                        if let secureDic = resultDic["creditMixAccountDetails"].dictionary {
                            if let responseArray =  secureDic["secured"]?.arrayValue{
                                if responseArray.count > 0 {
                                    self.secureArray.removeAll()
                                    for country in responseArray{
                                        self.secureArray.append(SecureModel(json: country))
                                    }
                                    self.secureTableView.reloadData()
                                }
                            }
                            if let resArray =  secureDic["unsecured"]?.arrayValue{
                                if resArray.count > 0 {
                                    self.unSecureArray.removeAll()
                                    for country in resArray{
                                        self.unSecureArray.append(SecureModel(json: country))
                                    }
                                    self.unsecureTableView.reloadData()
                                }
                            }
                            
                            if self.secureArray.count == 0{
                                self.secureHeight.constant = 0
                                self.secureTitleLabel.text = ""
                                self.secureDetailLabel.text = ""
                                self.secureTitleLabel.isHidden = true
                                self.secureDetailLabel.isHidden = true
                            }
                            else {
                                self.secureHeight.constant = CGFloat(75 * (self.secureArray.count+1))
                                self.secureView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
                            }
                            if self.unSecureArray.count == 0{
                                self.unsecureHeight.constant = 0
                                self.unsecureTitleLabel.text = ""
                                self.unsecureDetailLabel.text = ""
                                self.unsecureTitleLabel.isHidden = true
                                self.unsecureDetailLabel.isHidden = true
                            }
                            else {
                                self.unsecureHeight.constant = CGFloat(75 * (self.unSecureArray.count+1))
                                self.unsecureView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
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
}

extension LoanReportVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.loanApi()
            }
            else {
               // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
