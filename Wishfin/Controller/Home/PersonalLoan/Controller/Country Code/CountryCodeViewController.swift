//
//  CountryCodeViewController.swift
//  OOTTBusinessApp
//
//  Created by Vijay Yadav   on 21/06/17.
//  Copyright © 2017 Vijay Yadav  . All rights reserved.
//

import UIKit

/// delegate methods for Country Code class data
protocol CountryCodeDelegate {
    func countryCodeDidSelectCountry(withCountryName countryName:String, andCountryDialCode dialCode:String,isCheck:Bool,isState:Bool) -> Void
}

/// variable for country data
class Country {
    
    var countryName : String
    var countryCode : String
    var countryDialCode : String
    
    init(name : String, nameCode: String, dialCode:String) {
        
        self.countryCode = nameCode
        self.countryName = name
        self.countryDialCode = dialCode
    }
}

/// UIViewController class for showing country data
final class CountryCodeViewController: UIViewController {
    
    /// variable for country list
    @IBOutlet weak var tableCountryCodeListing: UITableView!
    
    /// variable for all country list data
    var arrayCountryCodeList : [[String:Any]] = []
    
    /// variable for searched data
    var filteredCountryCodeList : [[String:Any]] = []
    
    /// variable to indicate that search is active or not
    var isSearchActive = false
    
    /// variable to indicate that search is active or not
    var isCityCopmany = false
    
    var isStateChecks = false
    
    /// delegate variable
    var countryDelegate : CountryCodeDelegate?
    
    /// variable to indicate that search bar is visible or not
    var isSearchBarVisible = false
    
    /// UIViewController class life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupTableView()
    }
    
    /// UIViewController class life cycle method
    deinit {
        print("CountryCodeViewController Deinit")
    }
    
    /// UIViewController class life cycle method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- viewWillAppear
    /// UIViewController class life cycle method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.setupView()
        if isCityCopmany
        {
            getCompanyListApi()
        }
        else
        {
            //
            if isStateChecks
            {
                getStateListApi()
            }
            else
            {
                getCityListApi()
            }
        }
    }
    
    //MARK:- viewWillDisappear
    /// UIViewController class life cycle method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /// function to setup initial view
    func setupView() -> Void {
        updateNavigationBarUI()
    }
    
    /// MARK:- Initial table setup
    func setupTableView() -> Void {
        self.tableCountryCodeListing.delegate = self
        self.tableCountryCodeListing.dataSource = self
    }
    
    /// MARK:- Search button action
    @objc func onSearchButtonAction() -> Void {
        isSearchBarVisible = !isSearchBarVisible
        updateNavigationBarUI()
    }
    
    /// MARK:- Back button action
    @objc override func onBackButtonAction() -> Void {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

/// MARK: - extension for UITableViewDelegate, UITableViewDataSource methods
extension CountryCodeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredCountryCodeList.count : arrayCountryCodeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * ScaleFactorX
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = isSearchActive ? filteredCountryCodeList[indexPath.row] : arrayCountryCodeList[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "countryCodeCell") as! CountryCodeCell
        
        cell.selectionStyle = .none
        if isCityCopmany
        {
            cell.labelCountryName.text = (dict["company_name"] as! String)
//            cell.labelCountryCode.isHidden = true
        }
        else
        {
            if isStateChecks
            {
                cell.labelCountryName.text = (dict["state_name"] as! String)
//                cell.labelCountryCode.isHidden = true
            }
            else
            {
//                cell.labelCountryCode.isHidden = false
                cell.labelCountryName.text = (dict["city"] as! String)
//                cell.labelCountryCode.text = (dict["state"] as! String)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard countryDelegate != nil else {
            return
        }
        
        let country = isSearchActive ? filteredCountryCodeList[indexPath.row] : arrayCountryCodeList[indexPath.row]
        
        if isCityCopmany
        {
            countryDelegate?.countryCodeDidSelectCountry(withCountryName: country["company_name"] as! String, andCountryDialCode:"", isCheck: isCityCopmany, isState: isStateChecks)
        }
        else
        {
            if isStateChecks
            {
                countryDelegate?.countryCodeDidSelectCountry(withCountryName: country["state_name"] as! String, andCountryDialCode: country["state_code"] as! String, isCheck: isCityCopmany, isState: isStateChecks)
            }
            else
            {
                countryDelegate?.countryCodeDidSelectCountry(withCountryName: country["city"] as! String, andCountryDialCode: country["city"] as! String, isCheck: isCityCopmany, isState: isStateChecks)
            }
        }
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

/// MARK: - extension for SearchTextFieldDelegate methods
extension CountryCodeViewController: SearchTextFieldDelegate {
    
    func searchbarViewDidUpdateText(searchText: String, searchTextField: UITextField) {
        
        if searchText.isEmpty {
            
            isSearchActive = false
            filteredCountryCodeList.removeAll()
            tableCountryCodeListing.reloadData()
            return
        }
        
        filteredCountryCodeList = arrayCountryCodeList.filter({ (country) -> Bool in
            
            var name = ""//country["city"] as! String
            if isCityCopmany
            {
                name = country["company_name"] as! String
            }
            else
            {
                name = country["city"] as! String
            }
            
            let range = name.lowercased().range(of: searchText.lowercased())
            
            if range != nil {
                return true
            }
            
            return false
        })
        
        if filteredCountryCodeList.count == 0 {
            
            isSearchActive = false
            
            if !(searchTextField.text?.isEmpty)! {
                isSearchActive = true
            }
        }
        else {
            isSearchActive = true
        }
        
        tableCountryCodeListing.reloadData()
    }
    
    func searchbarViewDidTappedOnCancelBtn(searchTextField: UITextField) {
        
        searchTextField.text = ""
        searchbarViewDidUpdateText(searchText: "", searchTextField: searchTextField)
        isSearchBarVisible = !isSearchBarVisible
        updateNavigationBarUI()
    }
}

/// MARK: - extension for update ui data
extension CountryCodeViewController {
    
    func updateNavigationBarUI() {
        
        var duration: TimeInterval = 0
        
        if #available(iOS 11.0, *) {
            duration = 0.25
        }
        
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        
        UIView.transition(with: self.navigationController!.navigationBar, duration: duration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let `self` = self else {return}
            
            if self.isSearchBarVisible {
                
                self.navigationItem.title = nil
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = nil
                let searchView = SearchBarView ()
                searchView.frame.size = UIView.layoutFittingExpandedSize
                self.navigationItem.titleView = searchView
                searchView.delegate = self
                searchView.searchTextField.becomeFirstResponder()
            }
            else {
                self.navigationItem.titleView = nil
                //self.navigationController?.navigationBar.barTintColor = UIColor.black
                
                if self.isCityCopmany
                {
                    self.navigationItem.title = "Company"
                } else if self.isStateChecks {
                    self.navigationItem.title = "State"
                } else {
                    self.navigationItem.title = "City"
                }
                
                let button = UIBarButtonItem (image: #imageLiteral(resourceName: "searchIcon"), style: .plain, target: nil, action: nil)
                self.navigationItem.rightBarButtonItem = button
                
                let rightBarButton = button
                rightBarButton.target = self
                rightBarButton.action = #selector(self.onSearchButtonAction)
                
                let buttonBack = UIBarButtonItem (image: #imageLiteral(resourceName: "back"), style: .plain, target: nil, action: nil)
                self.navigationItem.leftBarButtonItem = buttonBack
                
                let leftBarButton = buttonBack
                leftBarButton.target = self
                leftBarButton.action = #selector(self.onBackButtonAction)
            }
            
        }, completion: {[weak self] (completed) in
            guard let `self` = self else {return}
            self.view.isUserInteractionEnabled = true
        })
    }
}




//MARK: Get Api call
extension CountryCodeViewController {
    func getCityListApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let getUrl = UrlName.baseUrl + "city-list"
            //   let getUrl = firstUrl
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    //  self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" || jsonValue["status"] == "SUCCESS"{
                    //result
                    if let responseArray = jsonValue["result"]?.arrayObject {
                        if responseArray.count > 0 {
                            self.arrayCountryCodeList = responseArray as! [[String : Any]]
                            self.tableCountryCodeListing.reloadData()
                            
                        }
                    }
                    //    self.arrayCountryCodeList =  jsonValue["result"] as [[String: Any]]
                }
                else {
                    
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
    func getStateListApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let getUrl = UrlName.baseUrl + "mfu-state-list"
            //   let getUrl = firstUrl
            let parme = ["":""]
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .post, parameters: parme, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    //  self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" || jsonValue["status"] == "SUCCESS"{
                    //result
                    if let responseArray = jsonValue["result"]?.arrayObject {
                        if responseArray.count > 0 {
                            self.arrayCountryCodeList = responseArray as! [[String : Any]]
                            self.tableCountryCodeListing.reloadData()
                            
                        }
                    }
                    //    self.arrayCountryCodeList =  jsonValue["result"] as [[String: Any]]
                }
                else {
                    print("===============")
                    
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
    //companyList
    
    func getCompanyListApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            let getUrl = UrlName.baseUrl + "company-list"
            //   let getUrl = firstUrl
            let headers = ["Authorization": Defaults.getHeader()]
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    //  self.showNoIntAlert()
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" || jsonValue["status"] == "SUCCESS"{
                    //result
                    if let responseArray = jsonValue["result"]?.arrayObject {
                        if responseArray.count > 0 {
                            for items in responseArray
                            {
                                let resultNew = items as? [String:Any]
                                
                                if resultNew!["company_name"] as! String != ""
                                {
                                    self.arrayCountryCodeList.append(items as! [String : Any])
                                }
                                
                            }
                            self.tableCountryCodeListing.reloadData()
                            
                        }
                    }
                    //    self.arrayCountryCodeList =  jsonValue["result"] as [[String: Any]]
                }
                else {
                    
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoInternetAlert()
        }
    }
    
}
