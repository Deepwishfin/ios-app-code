//
//  SelectLocationVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import CoreLocation

class SelectLocationVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var strTemp_CardCode = ""
    var selectCity = ""
    
    @IBOutlet weak var txtField_Location: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var placeArray = [AddressModel]()
    
    var locationManager: CLLocationManager!
    
    var dob_Lat:Double = 0.0
    var dob_Lng:Double = 0.0
    
    @IBOutlet weak var searchBtn_HeightCons: NSLayoutConstraint!
    @IBOutlet weak var searchbtn_TopCons: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        searchBtn_HeightCons.constant = 0
        searchbtn_TopCons.constant = 0
        searchBtn.setNeedsUpdateConstraints()
        
        tableView.isHidden = true
        self.tableView!.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: LocationTableViewCell.className(), bundle: nil), forCellReuseIdentifier: LocationTableViewCell.className())
        
        txtField_Location.setLeftPaddingPoints(10)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        
        dob_Lat = location.coordinate.latitude
        dob_Lng = location.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        if self.selectCity == ""
        {
            UtilityClass.showAlertWithTitle(message: "Please enter ctiy name", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        else
        {
            self.latlng_Search_Api(searchStr: self.selectCity)
        }
        
    }
    
    @IBAction func Action_CurrentLocation(_ sender: Any) {
        
//        let obj = DealsVC.init(nibName: DealsVC.className(), bundle: nil)
//        obj.hidesBottomBarWhenPushed = true
//        obj.str_CardCode = strTemp_CardCode
//        obj.str_Lat = dob_Lat
//        obj.str_Lng = dob_Lng
//        self.navigationController?.pushViewController(obj, animated: true)
        
        
        UserDefaults.standard.setValue(true, forKey: "rootLocationUpdate")
        UserDefaults.standard.setValue(self.selectCity, forKey: "obj_selectLocation")
        UserDefaults.standard.setValue(self.strTemp_CardCode, forKey: "obj_str_CardCode")
        UserDefaults.standard.setValue(self.dob_Lat, forKey: "obj_str_Lat")
        UserDefaults.standard.setValue(self.dob_Lng, forKey: "obj_str_Lng")
    
    
        
        Switcher.updateRootVC(SelIndex: 3)
        
//        let obj = SavingCardVC.init(nibName: SavingCardVC.className(), bundle: nil)
//        obj.hidesBottomBarWhenPushed = false
//        obj.selectLocation = self.selectCity
//        obj.str_CardCode = strTemp_CardCode
//        obj.str_Lat = dob_Lat
//        obj.str_Lng = dob_Lng
//        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
}

// MARK: - Tableview Methods
extension SelectLocationVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( !(cell != nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = self.placeArray[indexPath.row].descriptionStr
        cell!.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCity = self.placeArray[indexPath.row].descriptionStr
        self.txtField_Location.text = self.placeArray[indexPath.row].descriptionStr
        self.tableView.isHidden = true
    }
    
    
}


extension SelectLocationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length >= 3 {
            self.place_Search_Api(searchStr: newString as String)
        }
        
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("***** I am End now")
    }
}


//MARK: Get Api call
extension SelectLocationVC {
    func place_Search_Api(searchStr : String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = offerURLname.googleAPI_Url
            
            let getUrl = firstUrl + searchStr
            let headers = ["Authorization": ""]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                
                let chkStr:String = jsonValue["status"]?.stringValue ?? ""
                
                if chkStr == "OK" {
                    
                    let responseArray = jsonValue["predictions"]?.arrayValue
                    
                    self.placeArray.removeAll()
                    if responseArray!.count > 0 {
                        for country in responseArray! {
                            self.placeArray.append(AddressModel(json: country))
                        }
                        self.tableView.isHidden = false
                    } else {
                        self.tableView.isHidden = true
                    }
                    self.tableView!.reloadData()
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    
    func   latlng_Search_Api(searchStr : String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = offerURLname.latLngAPI_Url
            
            let urlString = firstUrl + searchStr
            guard let getUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            let headers = ["Authorization": ""]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                 
                  print(jsonValue) // RESULT JSON
                let chkStr:String = jsonValue["status"]?.stringValue ?? ""
                
                self.dismissHUD(isAnimated: true)
                if chkStr == "OK" {
                    //DealsVC
                    //SavingCardVC
                    
                    
                    
                    UserDefaults.standard.setValue(true, forKey: "rootLocationUpdate")
                        UserDefaults.standard.setValue(self.selectCity, forKey: "obj_selectLocation")
                        UserDefaults.standard.setValue(self.strTemp_CardCode, forKey: "obj_str_CardCode")
                        UserDefaults.standard.setValue(jsonValue["results"]?[0]["geometry"]["location"]["lat"].doubleValue ?? 0.0, forKey: "obj_str_Lat")
                        UserDefaults.standard.setValue(jsonValue["results"]?[0]["geometry"]["location"]["lng"].doubleValue ?? 0.0, forKey: "obj_str_Lng")
                    
                    Switcher.updateRootVC(SelIndex: 3)
                    
//                    let obj = SavingCardVC.init(nibName: SavingCardVC.className(), bundle: nil)
//                    obj.hidesBottomBarWhenPushed = false
//                    obj.str_CardCode = self.strTemp_CardCode
//                    obj.selectLocation = self.selectCity
//                    obj.str_Lat = jsonValue["results"]?[0]["geometry"]["location"]["lat"].doubleValue ?? 0.0
//                    obj.str_Lng = jsonValue["results"]?[0]["geometry"]["location"]["lng"].doubleValue ?? 0.0
                    
//                    self.navigationController?.pushViewController(obj, animated: true)
                    
                }
            })
        }else{
            self.showNoIntAlert()
        }
    }
}





extension SelectLocationVC {
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
