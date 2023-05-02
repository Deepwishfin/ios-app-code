//
//  DealsVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class DealsVC: UIViewController {

    @IBOutlet weak var btn_Location: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var str_Lat:Double = 0.0
    var str_Lng:Double = 0.0
     var str_CardCode = ""
    var selectLocation = ""
    
    var dealsOfflineArray = [DealsModel]()
    var dealsOnlineArray = [OnlineDealModel]()
    
    var loadMoreBool:Bool = true
    var isOnlineDeal:Bool = false
    
    var selectCard = [CreditUtiliseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.btn_Location setTitle(self.selectLocation, for: .normal)

        self.btn_Location .setTitle(self.selectLocation, for: .normal)
        // Do any additional setup after loading the view.
        // current
//        str_Lat = 17.384962
//        str_Lng = 78.487405
        
        
//        str_Lat = "0.8505"
//        str_Lng = "0.2711"
        
//        str_CardCode = "F5O6i3GBFnHEOjwciTvk"
        
        
        self.tableView!.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: DealTableViewCell.className(), bundle: nil), forCellReuseIdentifier: DealTableViewCell.className())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.deals_Offline_Api()
        
    }
    
    @IBAction func Action_Back(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_Location(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_CreditCard(_ sender: Any) {
        
    }
    
}

//MARK: Get Api call
extension DealsVC {
    func deals_Offline_Api() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            /*
             https://mtuzo.net/api/v4/offers/find?action=offers_near_me&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=0&count=50&iso=in&user_latitude=26.9124336&user_longitude=75.7872709&cardcodes[]=hzF4rBwerjNDxZgSgy5k
             */
            
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
                    self.tableView!.reloadData()
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
                  //  self.loadMoreBool = true
                     
                    self.tableView!.reloadData()
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}


extension DealsVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
//      self.cardsApi(cardType: self.str_CardType, bankCode: self.str_BankCode)
            }
            else {
              //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


 
// MARK: - Tableview Methods
extension DealsVC : UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOnlineDeal == true {
            if loadMoreBool == true {
                return self.dealsOnlineArray.count
            }
            if self.dealsOnlineArray.count >= 5 {
                return 5
            }
            return self.dealsOnlineArray.count
        } else {
            
            if loadMoreBool == true {
                return self.dealsOfflineArray.count
            }
            if self.dealsOfflineArray.count >= 5 {
                return 5
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
        obj.selectCard = selectCard
//        obj.strTemp_CardCode = str_CardCode
        self.navigationController?.pushViewController(obj, animated: true)
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if loadMoreBool == true {
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
        tableView.reloadData()
    }
     
}

