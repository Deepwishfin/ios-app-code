//
//  ExpiredDealsVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 09/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class ExpiredDealsVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var expiredDealsArry = [activeDealsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        expiredDealsApi()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        
        self.tblView.register(UINib.init(nibName: OfferDealsCell.className(), bundle: nil), forCellReuseIdentifier: OfferDealsCell.className())
        
        self.tblView.register(UINib.init(nibName: CardsNewCell.className(), bundle: nil), forCellReuseIdentifier: CardsNewCell.className())
        
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 190
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: - Navigation

extension ExpiredDealsVC: UITableViewDataSource, UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //            return //190
    //
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expiredDealsArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OfferDealsCell.className(), for: indexPath) as! OfferDealsCell
        cell.dealsDataShow(dict: expiredDealsArry[indexPath.row], viewContr: self, indexPath: indexPath.row)
        
        cell.expire_Soonlbl.isHidden = true
        cell.expire_TitleLbl.text = "Expired:"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "OfferDeals", bundle: Bundle.main).instantiateViewController(withIdentifier: "OfferDealsDetalsVC") as? OfferDealsDetalsVC
        vc!.detalsArry = [expiredDealsArry[indexPath.row]]
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}




//MARK: Get Api call Expired Deals
extension ExpiredDealsVC {
    func expiredDealsApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            guard let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId) else { return }
            let firstUrl = UrlName.baseUrl + UrlName.expiredDeals
            let secondUrl = "cibil_id=\(cibilId)"
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
                    
                    if jsonValue["status"] == "success" {
                        print(jsonValue["result"] as Any)
                        if let resultDic = jsonValue["result"]?.arrayValue {
                           
//                            toDoListReverse.reversed().forEach {print($0)}
                            for items in resultDic.reversed()
                            {
                                let daStr:String = items["expire_date"].stringValue
                                print(items)
                                if self.compareDateForBool(dStr: daStr) {
                                    self.expiredDealsArry.append(activeDealsModel(json: items))
                                }
                                
                            }
                            print(resultDic.count)
                            NotificationCenter.default.post(name: Notification.Name("dataSetOnDeals"), object: nil, userInfo: ["expiredDeal":"\(self.expiredDealsArry.count)"])
                            self.tblView.reloadData()
                            // self.activeDealsArry = resultDic
                        }
                    }
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    
    func compareDateForBool(dStr:String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        guard let sdate = dateFormatter.date(from: dStr) else { return false }
        
        let myString = dateFormatter.string(from: Date())
        
        guard let comDate = dateFormatter.date(from: myString) else { return false }
        
        
        if sdate < comDate {
            return  true
        }
        
        
        return false
    }
}


extension ExpiredDealsVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.expiredDealsApi()
            }
            else {
                // self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
