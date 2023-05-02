//
//  SavingCardVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 27/10/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import CoreLocation


class SavingCardVC: UIViewController ,CLLocationManagerDelegate {

    var str_Lat:Double = 0.0
    var str_Lng:Double = 0.0
    var str_CardCode = ""
    var selectLocation = ""
    var indexPathGet = 0
    
    var countEditClick = 0
    
    var dealsOfflineArray = [DealsModel]()
    var dealsOnlineArray = [OnlineDealModel]()
    
    var loadMoreBool:Bool = true
    var isOnlineDeal:Bool = false
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collctionView: UICollectionView!
    var creditUtiliseArray = [CreditUtiliseModel]()
    var locationManager: CLLocationManager!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (UserDefaults.standard.value(forKey: "rootLocationUpdate") != nil) {
            UserDefaults.standard.setValue(false, forKey: "rootLocationUpdate")
            
            str_CardCode = UserDefaults.standard.value(forKey: "obj_str_CardCode") as! String
            selectLocation = UserDefaults.standard.value(forKey: "obj_selectLocation") as! String
            str_Lat = UserDefaults.standard.value(forKey: "obj_str_Lat") as! Double
            str_Lng = UserDefaults.standard.value(forKey: "obj_str_Lng") as! Double
                                
        }
         
         
        setupTableView()
        hideNavigationBar()
        collectionSetup()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if selectLocation != ""
        {
            self.locationBtn.setTitle(selectLocation, for: .normal)
        }
        
        if str_Lat == 0.0 && str_Lng == 0.0 {
            getLocations()
        }
        
        cardsApi()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
  
    func getLocations()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
      func setupTableView() {
    self.tblView.register(UINib.init(nibName: DealTableViewCell.className(), bundle: nil), forCellReuseIdentifier: DealTableViewCell.className())
            
           tblView.delegate = self
            tblView.dataSource = self
        }
    
    func collectionSetup()
    {
        self.collctionView.register(UINib(nibName: "CardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionCell")
              let flowlayout = UICollectionViewFlowLayout()
              
              flowlayout.scrollDirection = .horizontal
              self.collctionView.collectionViewLayout = flowlayout
        }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            
            let location = locations.last! as CLLocation
    
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            str_Lat = location.coordinate.latitude
            str_Lng = location.coordinate.longitude
            
            locationManager.stopUpdatingLocation()
        }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
               if let ip = collctionView.indexPathForItem(at: center) {
                  print(" - - - - - - ",ip)
                            
                    self.str_CardCode = self.creditUtiliseArray[ip.row].cart_statusNew.card_name
                     print(" - - - - - - ",self.str_CardCode)
                    self.deals_Offline_Api()
                                                     
                
               }
        
        let pageWidth: Float = Float(self.collctionView.frame.width) + 10 //480 + 50
        // width + space
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }

        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
        
}


// MARK: - Tableview Methods
extension SavingCardVC : UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOnlineDeal == true {
            if loadMoreBool == true {
                return self.dealsOnlineArray.count
            }
            if self.dealsOnlineArray.count >= 50 {
                return 50
            }
            return self.dealsOnlineArray.count
        } else {
            
            if loadMoreBool == true {
                return self.dealsOfflineArray.count
            }
            if self.dealsOfflineArray.count >= 50 {
                return 50
            }
            return self.dealsOfflineArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealTableViewCell.className(), for: indexPath) as! DealTableViewCell
        
        if isOnlineDeal == true {
            let model = dealsOnlineArray[indexPath.row]
            cell.setupCellUIDataOnline(model: model)
        } else {
            let model = dealsOfflineArray[indexPath.row]
            cell.setupCellUIData(model: model)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = DealDetailsVC.init(nibName: DealDetailsVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        if isOnlineDeal == true {
            obj.isOnlineDeal = true
            let model = dealsOnlineArray[indexPath.row]
            obj.userLatitude = String(format:"%f", str_Lat)
            obj.userLongitude = String(format:"%f", str_Lng)
            obj.brandCode = model.brandCode
            obj.brandUrl = model.brandUrl
            obj.offerCode = model.offercode
        } else {
            obj.isOnlineDeal = false
            let model = dealsOfflineArray[indexPath.row]
            obj.userLatitude = String(format:"%f", str_Lat)
            obj.userLongitude = String(format:"%f", str_Lng)
            obj.brandCode = model.outletCode
            obj.offerCode = model.offerCode
        }
        obj.selectCard = [creditUtiliseArray[pageControl.currentPage]]
//        obj.strTemp_CardCode = str_CardCode
        self.navigationController?.pushViewController(obj, animated: true)
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if loadMoreBool == true {
            return 0
        }
        if self.dealsOnlineArray.count <= 0 && self.dealsOfflineArray.count <= 0 {
            return 0
        }
         
        return 44
    }
      
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
     
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewTemp = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        viewTemp.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let button = UIButton(frame: CGRect(x: 10, y: 5, width: (tableView.frame.size.width - 20), height: 34))
         button.setTitle("Load More", for: .normal)
         button.backgroundColor = #colorLiteral(red: 0.9778279066, green: 0.9778279066, blue: 0.9778279066, alpha: 1)
         button.setTitleColor(UIColor.lightGray, for: .normal)
        button.layer.cornerRadius = 4.0
         button.addTarget(self, action: #selector(self.LoadMoreTapped), for: .touchUpInside)
         viewTemp.addSubview(button)
 
        return viewTemp
    }
    

    @objc func LoadMoreTapped(sender : UIButton) {
        //Write button action here
        
        loadMoreBool = true
        tblView.reloadData()
    }
     
}


// MARK: - extension for UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout methods
extension SavingCardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pageControl.numberOfPages = creditUtiliseArray.count
         pageControl.isHidden = !(creditUtiliseArray.count > 1)
        
        return creditUtiliseArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
        cell.cardDataShow(dict: creditUtiliseArray[indexPath.row], viewContr: self, indexPath: indexPath.row)
        
        cell.cardEditBtn.tag = indexPath.row
        cell.cardEditBtn.addTarget(self, action: #selector(editCardbtnAction(_:)), for: .touchUpInside)
      

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth , height: 160)
    }
}


//MARK: Get Api call
extension SavingCardVC {
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
                            self.creditUtiliseArray.removeAll()
                            for country in responseArray{
                                self.creditUtiliseArray.append(CreditUtiliseModel(json: country))
                            }
                            
                            self.str_CardCode = self.creditUtiliseArray[0].cart_statusNew.card_name
                            
                            print(self.str_CardCode)
                            self.collctionView.reloadData()
                            
                            cardListArrayAbhi.removeAll()
                            cardListArrayAbhi = self.creditUtiliseArray
                            
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
                 self.deals_Offline_Api()
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}

//MARK: Get Api call
extension SavingCardVC {
    func deals_Offline_Api() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let firstUrl = offerURLname.nearME_baseUrl
            let secondUrl = "&user_latitude=\(str_Lat)&user_longitude=\(str_Lng)&cardcodes[]=\(str_CardCode)"
             
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
//             let getUrl = "https://mtuzo.net/api/v4/offers/find?action=offers_near_me&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&user_latitude=17.384962&user_longitude=78.487405&startid=0&count=50&cardcodes[]=F5O6i3GBFnHEOjwciTvk&iso=in"
                
            
            print("the deals_Offline_Api - - - - - ",getUrl)
                    
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.arrayValue
                    self.dealsOfflineArray.removeAll()
                    self.dealsOnlineArray.removeAll()
                    self.isOnlineDeal = false
                    if responseArray!.count > 0 {
                        for country in responseArray! {  self.dealsOfflineArray.append(DealsModel(json: country))
                        }
                        if self.dealsOfflineArray.count <= 5 {
                            self.loadMoreBool = true
                        } else {
                            self.loadMoreBool = false
                        }
                    } else {
                        self.loadMoreBool = false
                        self.deals_Online_Api()
                    }
                    self.tblView!.reloadData()
                } else {
                    self.loadMoreBool = false
                    self.deals_Online_Api()
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
            
            if str_CardCode == "" {
                str_CardCode = "F5O6i3GBFnHEOjwciTvk"
            }
            
            
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
                        if self.dealsOfflineArray.count <= 50 {
                            self.loadMoreBool = true
                        } else {
                            self.loadMoreBool = false
                        }
                    }
                    self.tblView!.reloadData()
                }
                self.dismissHUD(isAnimated: true)
            })
        } else {
            self.showNoIntAlert()
        }
    }
}

extension SavingCardVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
            //    self.cardsApi()
            }
            else {
               // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension SavingCardVC
{
    @IBAction func locationBtnAction(_ sender: Any) {
        let obj = SelectLocationVC.init(nibName: SelectLocationVC.className(), bundle: nil)
                obj.hidesBottomBarWhenPushed = true
              obj.strTemp_CardCode = str_CardCode
                self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    @IBAction func offerBtnAction(_ sender: Any) {
        guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
           
        let vc = UIStoryboard.init(name: "OfferDeals", bundle: Bundle.main).instantiateViewController(withIdentifier: "OfferDealsVC") as? OfferDealsVC
        vc!.cibilId = cibilId as! String
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func editCardbtnAction(_ sender: UIButton) {
          
        countEditClick += 1
        
        
        print(countEditClick)
        if countEditClick <= 1 {
            let obj = SelectCardViewController.init(nibName: SelectCardViewController.className(), bundle: nil)
            obj.hidesBottomBarWhenPushed = true
            obj.creditCardArray = [creditUtiliseArray[sender.tag]]
            obj.hidesBottomBarWhenPushed = true
            obj.cardCodeDelegate = { code in
                print(code)
                self.str_CardCode = code
                self.deals_Offline_Api()
            }
    //        self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: true, completion: nil)
             
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.countEditClick = 0
        }
        
    }
}
