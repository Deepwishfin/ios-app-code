//
//  DetailsVC.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreLocation

class DetailsVC: UIViewController, CLLocationManagerDelegate  {
   
    //MARK: IBOutlet
    @IBOutlet weak var imgWebView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sanctionLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var AcNoLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var yearTableView: UITableView!
    @IBOutlet weak var l4Label: UILabel!
    @IBOutlet weak var l3Label: UILabel!
    @IBOutlet weak var l1Label: UILabel!
    @IBOutlet weak var l2Label: UILabel!
    @IBOutlet weak var l5Label: UILabel!
    @IBOutlet weak var i1ImageView: UIImageView!
    @IBOutlet weak var i2ImageView: UIImageView!
    @IBOutlet weak var i5ImageView: UIImageView!
    @IBOutlet weak var i4ImageView: UIImageView!
    @IBOutlet weak var i3ImageView: UIImageView!
    @IBOutlet weak var r4Label: UILabel!
    @IBOutlet weak var r3Label: UILabel!
    @IBOutlet weak var r1Label: UILabel!
    @IBOutlet weak var r2Label: UILabel!
    @IBOutlet weak var r5Label: UILabel!
    @IBOutlet weak var totalPmntLabel: UILabel!
    @IBOutlet weak var onTimePmntLabel: UILabel!
    @IBOutlet weak var accLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var RoiLabel: UILabel!
    @IBOutlet weak var paymentTenLabel: UILabel!
    @IBOutlet weak var emiLabel: UILabel!
    @IBOutlet weak var paymFreqLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var v4View: UIView!
    @IBOutlet weak var v3View: UIView!
    @IBOutlet weak var v2View: UIView!
    @IBOutlet weak var v1View: UIView!
    @IBOutlet weak var scrView: UIScrollView!
    
    @IBOutlet weak var exclusiveCardNameLbl: UILabel!
    
    
    
    //MARK: Variables
    var detailModel = DetailsModel()
    var statusModel = PaymentStatusModel()
    var statusArray = [PStatusModel]()
    var array2017 = [PStatusModel]()
    var array2018 = [PStatusModel]()
    var array2019 = [PStatusModel]()
    var array2020 = [PStatusModel]()
    var yearsArray = [String]()
    var account_id = ""
    let commonColor = CommonMethods.hexStringToUIColor(hex: "00BDAA")
    let circleImage = UIImage(named: "fillCircle")
    var isCredit = false
    
    @IBOutlet weak var offer_View: UIView!
    @IBOutlet weak var colloection_View: UICollectionView!
 
     var str_Lat = ""
     var str_Lng = ""
     var str_CardCode = ""
    
    var dealsOfflineArray = [DealsModel]()
    var dealsOnlineArray = [OnlineDealModel]()
     
    var isOnlineDeal:Bool = false
    
    @IBOutlet weak var heightOfferCons: NSLayoutConstraint!
    
    var locationManager: CLLocationManager!
    
    
    var selectCard = [CreditUtiliseModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colloection_View.register(UINib(nibName: "dealCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "dealCollectionViewCell")
        
        
        setupView()
        
        // current
//        str_Lat = "17.384962"
//        str_Lng = "78.487405"
//        str_CardCode = "F5O6i3GBFnHEOjwciTvk"
        
        if str_CardCode == "" {
            self.heightOfferCons.constant = 0
            self.offer_View.setNeedsUpdateConstraints()
            offer_View.isHidden = true
        } else {
              
            let myArr = Defaults.getCardListAbhi()
            
            if myArr.count >= 1 {
                
                let cardCode = selectCard[0].account_number
                
                for item in myArr {
                    let list_cardCode = item["cardCode"]
                    if cardCode == list_cardCode {
                        
                        let cardnameStr = "".removeOptional(myStr: (String(describing: item["card_name_code"])))
                        
                        let newStr = cardnameStr.replacingOccurrences(of: "\"", with: "")
                         
                        self.exclusiveCardNameLbl.text = "Exclusive offers on your \(newStr)"
                         
//                        let card_network_code = item["card_network_code"]
//
//                        if card_network_code == "Visa" {
//                            cardTypeImg.image = UIImage(named: "visaCard")
//                        } else if card_network_code == "Master" {
//                            cardTypeImg.image = UIImage(named: "masterCard")
//                        } else if card_network_code == "American Express" {
//                            cardTypeImg.image = UIImage(named: "americanExpCard")
//                        } else if card_network_code == "Rupay" {
//                            cardTypeImg.image = UIImage(named: "rupayCard")
//                        } else if card_network_code == "Maestro" {
//                            cardTypeImg.image = UIImage(named: "mestroCard")
//                        } else if card_network_code == "Diners Club" {
//                            cardTypeImg.image = UIImage(named: "dinnerClubCard")
//                        }
//
                    }
                }
               
            }
        }
        
    }
    
    func setupView(){
        setDetailRefresh()
        scrView.isHidden = true
        otherView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        accountView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        paymentView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        topView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        offer_View.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        getDetailApi()
        self.setUpTableView()
        if str_CardCode == "" {
            offer_View.isHidden = true
        } else {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    self.deals_Online_Api()
                case .restricted:
                    self.deals_Online_Api()
                case .denied:
                    self.deals_Online_Api()
                case .authorizedAlways:
                    break
                case .authorizedWhenInUse:
                    break
                @unknown default:
                    self.deals_Online_Api()
                }
            } else {
                print("Location services are not enabled")
            }
            
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            
            let location = locations.last! as CLLocation
            
    //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            locationManager.stopUpdatingLocation()
            
            if str_Lat == "" {
                str_Lat = String(format:"%f", location.coordinate.latitude)
                str_Lng = String(format:"%f", location.coordinate.longitude)
                if str_CardCode == "" {
                    offer_View.isHidden = true
                } else {
                    self.deals_Offline_Api()
                }
            }
            
            
        }
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print(status)
        
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    func setDetailRefresh() {
        scrView.refreshControl = UIRefreshControl()
        scrView.refreshControl?.addTarget(self, action:#selector(refreshDetails),for: .valueChanged)
    }
    
    @objc func refreshDetails() {
        DispatchQueue.main.async {
            self.scrView.refreshControl?.endRefreshing()
        }
        yearsArray.removeAll()
        getDetailApi()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.yearTableView.register(UINib.init(nibName: YearCell.className(), bundle: nil), forCellReuseIdentifier: YearCell.className())
        self.yearTableView.tableFooterView = UIView()
    }
    
    //completed_percentage
    func updateUI(model:DetailsModel){
         
        statusModel = model.status
        titleLabel.text = model.member_name.isEmpty ? AlertField.NA :  model.member_name
        
       if self.exclusiveCardNameLbl.text == "Exclusive offers on your " {
        self.exclusiveCardNameLbl.text = "Exclusive offers on your \(titleLabel.text ?? "Card")"
        }
        
        
        
        
        loadWebView(url: model.icon)
        if isCredit {
            if let current = Int(model.current_balance),let credLimit = Int(model.credit_limit){
                paidLabel.text = "Used: ₹\(current.withCommas())"
                sanctionLabel.text = "Limit: ₹\(credLimit.withCommas())"
            }
            completeLabel.text = "Utilization: \(model.utilization_percentage)%"
        }
        else {
            
            if let sanction = Int(model.sanctioned_amount),let paid = Int(model.paid_amount){
                sanctionLabel.text = "Sanctioned: ₹\(sanction.withCommas())"
                paidLabel.text = "Paid: ₹\(paid.withCommas())"
            }
            completeLabel.text = "Completed: \(model.completed_percentage)%"
        }
        AcNoLabel.text = "Account Number: \(model.account_number)"
        bankNameLabel.text = "\(model.member_name) | \(model.account_type)"
        accLabel.text = model.account_number.isEmpty ? AlertField.NA :  model.account_number
        ownerLabel.text = model.ownership.isEmpty ? AlertField.NA :  model.ownership
        RoiLabel.text = model.rate_of_interest.isEmpty ? AlertField.NA :  "\(model.rate_of_interest)%"
        paymentTenLabel.text = model.repayment_tenure.isEmpty ? AlertField.NA :  model.repayment_tenure
        emiLabel.text = model.emi_amount.isEmpty ? AlertField.NA :  model.emi_amount
        paymFreqLabel.text = model.payment_frequency.isEmpty ? AlertField.NA :  model.payment_frequency
        
        let currentDate = Date()
         if currentDate > getDate(toDate: model.date_opened) {
            i5ImageView.image = circleImage
        }
        if currentDate > getDate(toDate: model.payment_start_date) {
            i4ImageView.image = circleImage
            v4View.backgroundColor = commonColor
        }
        if currentDate > getDate(toDate: model.date_reported_certified) {
            i3ImageView.image = circleImage
            v3View.backgroundColor = commonColor
        }
        if currentDate > getDate(toDate: model.date_of_last_payment) {
            i2ImageView.image = circleImage
            v2View.backgroundColor = commonColor
        }
        if currentDate > getDate(toDate: model.expected_completion_date) {
            i1ImageView.image = circleImage
            v1View.backgroundColor = commonColor
        }
        else {
            let lineLayer = CAShapeLayer()
            lineLayer.strokeColor =                                  CommonMethods.hexStringToUIColor(hex: "C5CCD6").cgColor
            lineLayer.lineWidth = 2
            lineLayer.lineDashPattern = [4,3]
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: v1View.frame.height-5)])
            lineLayer.path = path
            v1View.layer.addSublayer(lineLayer)
        }
        
        
        
        l1Label.text = model.expected_completion_date.isEmpty ? AlertField.NA : convertDate(toDate: model.expected_completion_date)
        l2Label.text = model.date_of_last_payment.isEmpty ? AlertField.NA : convertDate(toDate: model.date_of_last_payment)
        l3Label.text = model.date_reported_certified.isEmpty ? AlertField.NA : convertDate(toDate: model.date_reported_certified)
        l4Label.text = model.payment_start_date.isEmpty ? AlertField.NA : convertDate(toDate: model.payment_start_date)
        l5Label.text = model.date_opened.isEmpty ? AlertField.NA :  convertDate(toDate: model.date_opened)
        
        
        
        totalPmntLabel.text = "\(statusModel.total_payments)"
        onTimePmntLabel.text = "\(statusModel.on_time_paymentse)"
        if isCredit {
            if (model.utilization_percentage > 65){
                progressView.progressTintColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                completeLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
            }
            progressView.setProgress(Float(model.utilization_percentage) / 100.0, animated: false)
        }
        else {
            if (model.completed_percentage < 65){
                progressView.progressTintColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
                completeLabel.textColor = CommonMethods.hexStringToUIColor(hex: "ff922d")
            }
            progressView.setProgress(Float(model.completed_percentage) / 100.0, animated: false)
        }

        self.array2020 = self.statusArray.filter {
            $0.year == "2020"
        }
        self.array2019 = self.statusArray.filter {
            $0.year == "2019"
        }
        self.array2018 = self.statusArray.filter {
            $0.year == "2018"
        }
        self.array2017 = self.statusArray.filter {
            $0.year == "2017"
        }
        if self.array2020.count>0{
            self.yearsArray.append("2020")
        }
        if self.array2019.count>0{
            self.yearsArray.append("2019")
        }
        if self.array2018.count>0{
            self.yearsArray.append("2018")
        }
        if self.array2017.count>0{
            self.yearsArray.append("2017")
        }
        self.yearTableView.reloadData()
        print(self.yearsArray)
        let count = self.yearsArray.count
        tableHeight.constant = CGFloat(44*count)
        viewHeight.constant = CGFloat(116 + 44*count)
    }
    
    func loadWebView(url:String){
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }
        
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_ViewAllDeal(_ sender: Any) {
        
        let obj = DealsVC.init(nibName: DealsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        obj.str_CardCode = str_CardCode
        obj.selectCard = selectCard
        
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}

// MARK: UITableView Datasource
extension DetailsVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yearsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YearCell.className(), for: indexPath) as! YearCell
        cell.yrLabel.text = self.yearsArray[indexPath.row]
        
        switch self.yearsArray[indexPath.row] {
            case "2020":
                if self.array2020.count>0{
                 cell.setupCellUI(model: self.array2020)
             }
        case "2019":
            if self.array2019.count>0{
                cell.setupCellUI(model: self.array2019)
            }
        case "2018":
            if self.array2018.count>0{
                cell.setupCellUI(model: self.array2018)
            }
        case "2017":
            if self.array2017.count>0{
                cell.setupCellUI(model: self.array2017)
            }
        default:
            print("")
        }
        return cell
    }
}
//MARK: Get Api call
extension DetailsVC {
    func getDetailApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
            let firstUrl = UrlName.baseUrl + UrlName.getDetail
            let secondUrl = "cibil_id=\(cibilId)&cibil_ac_detail_id=\(account_id)"
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
                    if let responseArray = jsonValue["result"]?.arrayValue {
                        if responseArray.count > 0{
                           self.detailModel = DetailsModel(json: responseArray[0])
                            for model in self.detailModel.status.statusArray{
                                self.statusArray.append(model)
                            }
                            self.updateUI(model: self.detailModel)
                        }
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    
    func deals_Offline_Api() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = offerURLname.nearME_baseUrl
            let secondUrl = "&user_latitude=\(str_Lat)&user_longitude=\(str_Lng)&cardcodes[]=\(str_CardCode)"
             
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            
            
            
            // let getUrl = "https://mtuzo.net/api/v4/offers/find?action=offers_near_me&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&user_latitude=17.384962&user_longitude=78.487405&startid=0&count=50&cardcodes[]=F5O6i3GBFnHEOjwciTvk&iso=in"
             
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                // vijay yadav
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.arrayValue
                    self.dealsOfflineArray.removeAll()
                     self.dealsOnlineArray.removeAll()
                    self.isOnlineDeal = false
                    if responseArray!.count > 0 {
                        for country in responseArray! {  self.dealsOfflineArray.append(DealsModel(json: country))
                        }
                    } else {
                        self.deals_Online_Api()
                    }
                    self.colloection_View!.reloadData()
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    
    func deals_Online_Api() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = offerURLname.OnlineOffer_baseUrl
            let secondUrl = "&cardcodes[]=\(str_CardCode)"
             
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
             
            
            // https://mtuzo.net/api/v4/offers/find?action=online_offers&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=0&count=5&cardcodes[]=F5O6i3GBFnHEOjwciTvk&iso=in
             
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.arrayValue
                     
                    if responseArray!.count > 0 {

                        self.isOnlineDeal = true
                        for country in responseArray! {
                            self.dealsOnlineArray.append(OnlineDealModel(json: country))
                        }
                    } else {
                        self.heightOfferCons.constant = 0
                        self.offer_View.setNeedsUpdateConstraints()
                        self.offer_View.isHidden = true
                    }
                    
                    self.colloection_View!.reloadData()
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}

extension DetailsVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.getDetailApi()
            }
            else {
             //   self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: CollectionView Method
extension DetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOnlineDeal == true {
            if self.dealsOnlineArray.count >= 3 {
                return 3
            }
            return self.dealsOnlineArray.count
        } else {
            if self.dealsOfflineArray.count >= 3 {
                return 3
            }
            return self.dealsOfflineArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : dealCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealCollectionViewCell", for: indexPath as IndexPath) as! dealCollectionViewCell
         
        
        if isOnlineDeal == true {
            let model = dealsOnlineArray[indexPath.row]
            cell.setupCellUIDataOnline(model: model)
        } else {
            let model = dealsOfflineArray[indexPath.row]
            cell.setupCellUIData(model: model)
        }
         
        
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = DealDetailsVC.init(nibName: DealDetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        if isOnlineDeal == true {
            obj.isOnlineDeal = true
            let model = dealsOnlineArray[indexPath.row]
            obj.userLatitude = str_Lat
            obj.userLongitude = str_Lng
            obj.brandCode = model.brandCode
            obj.offerCode = model.offercode
        } else {
            obj.isOnlineDeal = false
            let model = dealsOfflineArray[indexPath.row]
            obj.userLatitude = str_Lat
            obj.userLongitude = str_Lng
            obj.brandCode = model.outletCode
            obj.offerCode = model.offerCode
        }
        obj.selectCard = selectCard
        
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height - 20)
    }
}
