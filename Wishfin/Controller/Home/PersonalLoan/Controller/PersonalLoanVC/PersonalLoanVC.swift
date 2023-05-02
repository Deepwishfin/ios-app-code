//
//  PersonalLoanVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 06/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import DropDown
class PersonalLoanVC: UIViewController {
    
    @IBOutlet weak var appSlider: UISlider!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var salryImg: UIImageView!
    @IBOutlet weak var emplyImg: UIImageView!
    @IBOutlet weak var salryLbl: UILabel!
    @IBOutlet weak var emplyLbl: UILabel!
    @IBOutlet weak var salariView: UIView!
    @IBOutlet weak var emplyeView: UIView!
    @IBOutlet weak var employeDropDwonBtn: UIButton!
    
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var companyTxt: UITextField!
    @IBOutlet weak var incomeTxt: UITextField!
    
    let dropDown = DropDown()
    var isTypeCheck = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appSlider.value = 500000
        
        // Do any additional setup after loading the view.
        appSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        self.emplyeView.isHidden = true
        dropDown.anchorView = employeDropDwonBtn // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["0 - 40 Lacs", "40 Lacs - 1 Cr", "1 Cr - 3Crs","3Crs @ above"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.employeDropDwonBtn.setTitle(item, for: .normal)
        }
        dropDown.hide()
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        // self.showSliderValue.text = "\(self.appSlider.value)"
        print("- - - - - ",self.appSlider.value)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            
            let fixed = roundf(slider.value / 100) * 100;
            let truncatedFixed = Int(fixed)
            
            self.priceLbl.text = "\(truncatedFixed)"
            switch touchEvent.phase {
            case .began:
                // handle drag began
                print(" - - - - ",slider.value)
            case .moved:
                // handle drag moved
                print(" - - - - ",slider.value)
            case .ended:
                // handle drag ended
                print(" - - - - ",slider.value)
            default:
                break
            }
        }
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

// MARK: - Action Method
extension PersonalLoanVC
{
    @IBAction func continueBtnClicked(_ sender: Any) {
        //ProceedQuoteVC
        if validateInputData()
        {
            personalLoanApi()
        }
        
    }
    
    @IBAction func salaryBtnClicked(_ sender: Any) {
        //PersonalLoanVC
        self.statusSalaryOrEmployess(status: "salary")
    }
    @IBAction func employeedBtnClicked(_ sender: Any) {
        //PersonalLoanVC
        self.statusSalaryOrEmployess(status: "")
    }
    
    @IBAction func dropDwonBtnClicked(_ sender: Any) {
        dropDown.show()
        
        
    }
    func statusSalaryOrEmployess(status : String)
    {
        if status == "salary"
        {
            self.emplyLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryImg.image = UIImage (named: "checkYes")
            self.emplyImg.image = UIImage (named: "checkboxBlank")
            self.salariView.isHidden = false
            self.emplyeView.isHidden = true
            self.isTypeCheck = false
        }
        else
        {
            self.emplyLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryImg.image = UIImage (named: "checkboxBlank")
            self.emplyImg.image = UIImage (named: "checkYes")
            self.emplyeView.isHidden = false
            self.salariView.isHidden = true
            self.isTypeCheck = true
        }
    }
    
    
}



extension PersonalLoanVC : UITextFieldDelegate
{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == incomeTxt  {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
              
            return newString.length <= maxLength
        }
        
       return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == cityTxt
        {
            let countryCode = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            let navigation = UINavigationController.init(rootViewController: countryCode)
            countryCode.countryDelegate = self
            navigation.modalPresentationStyle = .fullScreen
            countryCode.isCityCopmany = false
            countryCode.isStateChecks = false
            self.present(navigation, animated: true, completion: nil)
        }
        else if textField == companyTxt
        {
            let countryCode = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
            let navigation = UINavigationController.init(rootViewController: countryCode)
            countryCode.countryDelegate = self
            countryCode.isCityCopmany = true
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
        
    }
}
 

/// MARK: - extension for CountryCodeDelegate methods
extension PersonalLoanVC : CountryCodeDelegate {
    func countryCodeDidSelectCountry(withCountryName countryName: String, andCountryDialCode dialCode: String, isCheck: Bool, isState: Bool) {
        
        print("countryName : ", countryName)
        print("dialCode : ", dialCode)
        if isCheck
        {
            self.companyTxt.text = countryName
        }
        else
        {
            self.cityTxt.text = countryName
        }
    }
    
}


extension PersonalLoanVC
{
    func personalLoanApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.personalLoan
            let headers = ["Authorization": Defaults.getHeader()]
            
            var annualturnover = "0"
            if isTypeCheck
            {
                annualturnover = self.employeDropDwonBtn.titleLabel!.text!
            }
            
            
            var model = LoginModel()
            
            if let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails),
                let logmodel = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel {
                model = logmodel
            } else {
                return
            }
            
            let nameStr = model.first_name + " " + model.middle_name + " " + model.last_name
            
            let params = ["resource_pagename": "personal-loan-eligibility",
                          "resource_source": "",
                          "resource_referal": "http://zend.loc/personal-loan-eligibility",
                          "resource_ip_address": "127.0.0.1",
                          "resource_querystring": "",
                          "utm_source": "",
                          "utm_medium": "",
                          "utm_campaign": "",
                          "pagename": "personal-loan-eligibility",
                          "source": "wishfinPLEligibility",
                          "loanamount": self.priceLbl.text!,
                          "city": self.cityTxt.text!,
                          "occupation": "1",
                          "monthlyincome": self.incomeTxt.text!,
                          "fullname": nameStr,
                          "mobileno": model.mobile_number,
                          "emailid": model.email_id,
                          "companyname": self.companyTxt.text ?? "",
                          "annualturnover": annualturnover,
                          "accept": "1",
                          "submit": ""] as [String : Any]
            print(params)
           
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: firstUrl, method: .post, parameters: params, completionHandler: { (json, status) in
                
                self.dismissHUD(isAnimated: true)
                
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    print(jsonValue["result"] as Any)
                    if let resultDic = jsonValue["result"]?.dictionary {
                        
                        let vc = UIStoryboard.init(name: "PersonalLoan", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProceedQuoteVC") as? ProceedQuoteVC
                        vc!.personalLoanId = resultDic["id"]!.stringValue
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                    
                }
                else
                {
                    self.showToast(messsage: jsonValue["message"]?.stringValue ?? "", position: .bottom)
                }
                
                //   print(jsonValue)
                
            })
            
            
        } else {
            self.showNoIntAlert()
        }
    }
}


extension PersonalLoanVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.personalLoanApi()
            }
            else {
                //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
//agoutam

// MARK: - Validtion Setup ----------------------------------
extension PersonalLoanVC {
    
    func validateInputData () -> Bool {
        
        var isError : Bool = true
        if incomeTxt.text!.isEmpty {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter monthly income", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        
        else if cityTxt.text!.isEmpty {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter city", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        
        else if isTypeCheck && self.employeDropDwonBtn.titleLabel?.text == "Annual Turnover"
        {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please select annual turnover", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        
        else if !isTypeCheck && cityTxt.text!.isEmpty
        {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter company name", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
         
        
        return isError
    }
}
