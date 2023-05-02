//
//  ProceedQuoteVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 08/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import DropDown

class ProceedQuoteVC: UIViewController {
    
    @IBOutlet weak var salryImg: UIImageView!
    @IBOutlet weak var emplyImg: UIImageView!
    @IBOutlet weak var salryLbl: UILabel!
    @IBOutlet weak var emplyLbl: UILabel!
    
    @IBOutlet weak var cardHolderYesLbl: UILabel!
    @IBOutlet weak var cardHolderNoLbl: UILabel!
    @IBOutlet weak var cardHolderYesImg: UIImageView!
    @IBOutlet weak var cardHolderNoImg: UIImageView!
    
    
    @IBOutlet weak var cardGenderMaleLbl: UILabel!
    @IBOutlet weak var cardGenderFeMaleLbl: UILabel!
    @IBOutlet weak var cardGenderMaleImg: UIImageView!
    @IBOutlet weak var cardGenderFeMaleImg: UIImageView!
    
    
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var companyTypeBtn: UIButton!
    
    @IBOutlet weak var noOfYearTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var pinCodeTxt: UITextField!
    @IBOutlet weak var borderView: UIView!
    
    var personalLoanId = ""
    var gender = "1"
    var residencestatus = "1"
    var cardholder = "0"
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.cornerRadius = 10;
        borderView.layer.masksToBounds = true;
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.borderWidth = 1;
        
        dropDown.anchorView = companyTypeBtn // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Company Type", "Private Limited", "MNC Private Limited","Limited","Govt.(Central/State)","PSU (Public Sector Undertaking)"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.companyTypeBtn.setTitle(item, for: .normal)
        }
        dropDown.hide()
        
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    @IBAction func stateBtnClicked(_ sender: Any) {
        
        let countryCode = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        let navigation = UINavigationController.init(rootViewController: countryCode)
        countryCode.countryDelegate = self
        navigation.modalPresentationStyle = .fullScreen
        countryCode.isCityCopmany = false
        countryCode.isStateChecks = true
        self.present(navigation, animated: true, completion: nil)
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
extension ProceedQuoteVC
{
    @IBAction func banksQuotesBtnClicked(_ sender: Any) {
        
        if validateInputData()
        {
            processLoanApi()
        }
        
        
    }
    
    @IBAction func dropDwonBtnClicked(_ sender: Any) {
        dropDown.show()
        
    }
    @IBAction func salaryBtnClicked(_ sender: Any) {
        //PersonalLoanVC
        self.statusSalaryOrEmployess(status: "salary")
    }
    @IBAction func employeedBtnClicked(_ sender: Any) {
        self.statusSalaryOrEmployess(status: "")
    }
    
    @IBAction func cardHolderYesBtnClicked(_ sender: Any) {
        self.statusCardHoler(status: "Yes")
    }
    @IBAction func cardHolderNoBtnClicked(_ sender: Any) {
        self.statusCardHoler(status: "")
    }
    
    @IBAction func cardGenderMaleBtnClicked(_ sender: Any) {
        self.statusGenderHoler(status: "Male")
    }
    @IBAction func cardGenderFeMaleBtnClicked(_ sender: Any) {
        self.statusGenderHoler(status: "")
    }
    
    func statusCardHoler(status : String)
    {
        if status == "Yes"
        {
            cardholder = "1"
            self.cardHolderNoImg.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardHolderYesLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardHolderYesImg.image = UIImage (named: "checkYes")
            self.cardHolderNoImg.image = UIImage (named: "checkboxBlank")
        }
        else
        {
            cardholder = "0"
            self.cardHolderNoImg.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardHolderYesLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardHolderNoImg.image = UIImage (named: "checkYes")
            self.cardHolderYesImg.image = UIImage (named: "checkboxBlank")
        }
    }
    
    func statusSalaryOrEmployess(status : String)
    {
        if status == "salary"
        {
            residencestatus = "1"
            self.emplyLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryImg.image = UIImage (named: "checkYes")
            self.emplyImg.image = UIImage (named: "checkboxBlank")
        }
        else
        {
            residencestatus = "2"
            self.emplyLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.salryImg.image = UIImage (named: "checkboxBlank")
            self.emplyImg.image = UIImage (named: "checkYes")
        }
    }
    
    
    func statusGenderHoler(status : String)
    {
        if status == "Male"
        {
            gender = "1"
            self.cardGenderMaleLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardGenderFeMaleLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardGenderMaleImg.image = UIImage (named: "checkYes")
            self.cardGenderFeMaleImg.image = UIImage (named: "checkboxBlank")
        }
        else
        {
             gender = "2"
            self.cardGenderMaleLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardGenderFeMaleLbl.tintColor = UIColor.init(red: 0.0/255, green: 23.0/255, blue: 56.0/255, alpha: 1.0)
            self.cardGenderMaleImg.image = UIImage (named: "checkboxBlank")
            self.cardGenderFeMaleImg.image = UIImage (named: "checkYes")
        }
    }
}

extension ProceedQuoteVC : UITextFieldDelegate
{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == noOfYearTxt || textField == pinCodeTxt  {
            var maxLength = 10
            
            if textField == noOfYearTxt {
                maxLength = 2
            }
            if textField == pinCodeTxt {
                maxLength = 6
            }
            
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
        
        
    }
}


/// MARK: - extension for CountryCodeDelegate methods
extension ProceedQuoteVC : CountryCodeDelegate {
    
    func countryCodeDidSelectCountry(withCountryName countryName: String, andCountryDialCode dialCode: String, isCheck: Bool, isState: Bool) {
        
        print("countryName : ", countryName)
        print("dialCode : ", dialCode)
        if isCheck
        {
            // self.companyTxt.text = countryName
            self.stateBtn.setTitle(countryName, for: .normal)
            
        }
        else if isState
        {
            self.stateBtn.setTitle(countryName, for: .normal)
        }
        else
        {
            self.cityTxt.text = countryName
        }
    }
    
}


extension ProceedQuoteVC
{
    func processLoanApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.personalLoanContinue
            let headers = ["Authorization": Defaults.getHeader()]
            
            var model = LoginModel()
            
            if let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails),
                let logmodel = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel {
                model = logmodel
            } else {
                return
            }
            
            let params = ["prorequestid": personalLoanId,
                          "professiontype": "2",
                          "currentexp": "3",
                          "totalexp": self.noOfYearTxt.text!,
                          "cardholder": cardholder,
                          "cardvintage": "0",
                          "primarybankacc": "ICICI Bank",
                          "residencestatus": residencestatus,
                          "isloanhidden": "0",
                          "panno": model.pancard,
                          "dob": model.date_of_birth,
                          "gender": gender,
                          "residenceaddress": self.addressTxt.text!,
                          "residencepincode": self.pinCodeTxt.text!,
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
                        let vc = UIStoryboard.init(name: "PersonalLoan", bundle: Bundle.main).instantiateViewController(withIdentifier: "BanksQuotesVC") as? BanksQuotesVC
                        vc?.personalLoanId = resultDic["id"]!.stringValue
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                    
                }
                else
                {
                    
                }
                
                //   print(jsonValue)
                
            })
            
            
        }else{
            // self.showNoIntAlert()
        }
    }
}


// MARK: - Validtion Setup ----------------------------------
extension ProceedQuoteVC {
    
    func validateInputData () -> Bool {
        
        var isError : Bool = true
        
        if self.companyTypeBtn.titleLabel?.text == "Company Type" {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please select company type", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        else if noOfYearTxt.text!.isEmpty {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter no. of years in this company", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        else if addressTxt.text!.isEmpty {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter residence address ", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        else if pinCodeTxt.text!.isEmpty {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please enter residence pincode", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        else if pinCodeTxt.text!.count <= 5 {
            isError = false
             UtilityClass.showAlertWithTitle(message: "Please enter 6 digits pincode", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
            
        else if self.stateBtn.titleLabel?.text == "Please Select State" {
            isError = false
            UtilityClass.showAlertWithTitle(message: "Please select state", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
        
        
        
        return isError
    }
}
