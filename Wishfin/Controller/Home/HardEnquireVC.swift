//
//  HardEnquireVC.swift
//  Tutorial
//
//  Created by Wishfin on 12/09/19.
//  Copyright © 2019 Ved. All rights reserved.
//

import UIKit

class HardEnquireVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var hardEnqLabel: UILabel!
    @IBOutlet weak var hardEnqTableView: UITableView!
    @IBOutlet weak var lastInqLabel: UILabel!
    @IBOutlet weak var totalInqLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var inqCountLabel: UILabel!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

    
    //MARK: - Variables
    var inqArray = [InquiryModel]()
    var cibilId = ""
    var lastMonthInquiryCount = 0
    var last6MonthInquiryCount = 0
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    /// Setting up View
    func setupView(){
        setHardEnqRefresh()
        scrView.isHidden = true
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        lastInqLabel.text = "\(last6MonthInquiryCount)"
        inqCountLabel.text = "\(lastMonthInquiryCount)"
        setUpTableView()
        createCircle()
        hardEnquiryApi()
    }
    
    func setHardEnqRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshHardEnq),for: .valueChanged)
    }
    
    @objc func refreshHardEnq() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        hardEnquiryApi()
    }
    
    func createCircle(){
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleView.frame.width, height: circleView.frame.height)).cgPath
        circleLayer.lineWidth = 4.0
        circleView.layer.addSublayer(circleLayer)
        circleLayer.strokeColor = CommonMethods.hexStringToUIColor(hex: "00BDAA").cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        if (self.lastMonthInquiryCount > 2){
            headingLabel.text = "High Number of inquiries"
            subHeadingLabel.text = "The high number of credit inquiries affects your CIBIL report Negatively"
            self.inqCountLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
            circleLayer.strokeColor = CommonMethods.hexStringToUIColor(hex: "ff922d").cgColor
        }
        else {
            self.inqCountLabel.textColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
            circleLayer.strokeColor = CommonMethods.hexStringToUIColor(hex: "00BDAA").cgColor
        }
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.hardEnqTableView.register(UINib.init(nibName: HardEnquireCell.className(), bundle: nil), forCellReuseIdentifier: HardEnquireCell.className())
        self.hardEnqTableView.tableFooterView = UIView()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: UITableView Datasource
extension HardEnquireVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HardEnquireCell.className(), for: indexPath) as! HardEnquireCell
        cell.setupCellUIData(model: inqArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView Delegate
extension HardEnquireVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: Get Api call
extension HardEnquireVC {
    func hardEnquiryApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = UrlName.baseUrl + UrlName.getCibitFactor
            let secondUrl = "cibil_id=\(cibilId)&type=\(UrlName.hardEnq)"
            
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
                        
                       self.totalInqLabel.text = resultDic["inquiryCount"].stringValue
                        let responseArray =  resultDic["inquiriesDetails"].arrayValue
                        if responseArray.count > 0 {
                            self.inqArray.removeAll()
                            for country in responseArray{
                                self.inqArray.append(InquiryModel(json: country))
                            }
                            self.inqArray = Array(self.inqArray.reversed())
                            self.hardEnqTableView.reloadData()
                        }
                        if self.inqArray.count == 0{
                            self.hardEnqLabel.isHidden = true
                            self.bottomHeight.constant = 0
                        }
                        else {
                            self.hardEnqLabel.isHidden = false
                            let creditCount = self.inqArray.count
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

extension HardEnquireVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.hardEnquiryApi()
            }
            else {
            //    self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
