//
//  BanksQuotesVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 07/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class BanksQuotesVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var lblPromo1TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var img1View: UIImageView!
    @IBOutlet weak var img2View: UIImageView!
    @IBOutlet weak var img3View: UIImageView!
    @IBOutlet weak var img4View: UIImageView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondeLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    @IBOutlet weak var bank_Qu_Lbl: UILabel!
    
    var lblSort:String = ""
    var personalLoanId = ""
    
    var banklist = [Bank_Quote_list]()
    var customerDetails = Loan_Customer_list()
    var ApplyInableDisable = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.lblPromo1TopConstraint.constant = 2000
        self.firstLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.firstLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.firstLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.firstLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.filterView!.addGestureRecognizer(tap)
        
        
        bank_Qu_Lbl.text = "0 Bank Quote"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.BanksQuotesApi()
    }
    /*
     
     /v1/personal-loan-get-quote/(use saved id)

     /select-opted-bank
     
     */
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        UIView.animate(withDuration: 6.0, delay: 0.2, options: [.curveLinear], animations: {
            self.lblPromo1TopConstraint.constant = 2000
        }) { (finished) in
            if finished {
                // Repeat animation to bottom to top
                // self.bottom()
            }
        }
    }
     
    func setupTableView() {
        
        self.tblView.register(UINib.init(nibName: BanksQuotesCell.className(), bundle: nil), forCellReuseIdentifier: BanksQuotesCell.className())
        
        tblView.delegate = self
        tblView.dataSource = self
    }
}

// MARK: - Navigation

extension BanksQuotesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BanksQuotesCell.className(), for: indexPath) as! BanksQuotesCell
         
        cell.instantApporvedBtn.isHidden = true
//        cell.instantApplyBtn.isHidden = true
        cell.tenureLbl.isHidden = true
        cell.instPresentLbl.isHidden = true
//        cell.instTitleLbl.isHidden = true
        cell.monthltTitleLbl.isHidden = true
        cell.monthlyPayLbl.isHidden = true
        
//        cell.bankImg
        
        
        cell.bankNameLbl.text = banklist[indexPath.row].bank_name
        
//        cell.loanAmtTitleLbl.isHidden = true
//        cell.loanAmtValLbl.isHidden = true
        cell.loanAmtValLbl.text = customerDetails.loan_amount
        
//        cell.monthlyPayLbl.text = customerDetails.total_monthly_obligation
        
        let chkStr = ApplyInableDisable[indexPath.row]
        
        if chkStr == "0" {
            cell.instantApplyBtn.isUserInteractionEnabled = true
            cell.instantApplyBtn.backgroundColor = cell.instPresentLbl.textColor
            cell.instantApplyBtn.tag = indexPath.row
            cell.instantApplyBtn.addTarget(self, action: #selector(self.InstantApplyBtnClicked(_:)), for: .touchUpInside)
        } else {
            cell.instantApplyBtn.isUserInteractionEnabled = false
            cell.instantApplyBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func InstantApplyBtnClicked(_ sender: Any) {
        let btn = sender as! UIButton
        
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.personalLoanSelectBank
            let headers = ["Authorization": Defaults.getHeader()]
            
            
            let params = [ "bank_code": banklist[btn.tag].bank_code,
                "lead_id": personalLoanId,
                "type": "pl"] as [String : Any]
           
            
            print(params)
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: firstUrl, method: .post, parameters: params, completionHandler: { (json, status) in
                
                self.dismissHUD(isAnimated: true)
                
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "success" {
                    print(jsonValue["result"] as Any)
                    
                    self.showToast(messsage: "Your interests submmitted successfully.", position: .bottom)
                    self.ApplyInableDisable[btn.tag] = ""
                    self.tblView.reloadData()
//                    self.showToast(messsage: jsonValue["message"]?.stringValue ?? "", position: .bottom)
                    
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
 
// MARK: - Bottm Action Sheet
extension BanksQuotesVC
{
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        UIView.animate(withDuration: 6.0, delay: 0.2, options: [.curveLinear], animations: {
            self.lblPromo1TopConstraint.constant = 2000
        }) { (finished) in
            if finished {
                // Repeat animation to bottom to top
                // self.bottom()
            }
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sortBtnClicked(_ sender: Any) {
        Up()
    }
    
    @IBAction func filterActionBtnClicked(_ sender: UIButton) {
        
        self.img1View.image = UIImage (named: "radio_button_unchecked")
        self.img2View.image = UIImage (named: "radio_button_unchecked")
        self.img3View.image = UIImage (named: "radio_button_unchecked")
        self.img4View.image = UIImage (named: "radio_button_unchecked")
        self.firstLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.secondeLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.thirdLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        self.fourthLbl.font = UIFont(name: "Poppins-Regular", size: 14)!
        if sender.tag == 1
        {
            self.img1View.image = UIImage (named: "radio-on-button")
            self.firstLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        }
        else if sender.tag == 2
        {
            self.img2View.image = UIImage (named: "radio-on-button")
            self.secondeLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        }
        else if sender.tag == 3
        {
            self.img3View.image = UIImage (named: "radio-on-button")
            self.thirdLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        } else {
            self.img4View.image = UIImage (named: "radio-on-button")
            self.fourthLbl.font = UIFont(name: "Poppins-SemiBold", size: 16)!
        }
        
    }
}

extension BanksQuotesVC{
    
    
    
    func Up()  {
        
        UIView.animate(withDuration: 6.0, delay: 0.2, options: [.transitionCurlUp], animations: {
            self.lblPromo1TopConstraint.constant = 0
        }) { (finished) in
            if finished {
                // Repeat animation to bottom to top
                // self.bottom()
            }
        }
        
    }
    
}


extension BanksQuotesVC
{
    func BanksQuotesApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.getquotepersonalLoan + personalLoanId
            let headers = ["Authorization": Defaults.getHeader(),
                           "Content-Type": "application/json"]
            
            print(firstUrl)
            print(headers)
            
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: firstUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                
                self.dismissHUD(isAnimated: true)
                
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                if jsonValue["status"] == "SUCCESS" {
                    print(jsonValue["result"] as Any)
                     
                    
                    if let bankJson = jsonValue["result"]?.dictionaryValue {
                        if let resultDic = bankJson["bank-quote"]?.arrayValue {
                            self.banklist.removeAll()
                            self.ApplyInableDisable.removeAll()
                            for items in resultDic {
                                self.banklist.append(Bank_Quote_list(json: items))
                                self.ApplyInableDisable.append("0")
                            }
                            print(resultDic.count)
                            
                            self.bank_Qu_Lbl.text = "\(resultDic.count) Bank Quotes"
                            
                            if let customerModel = bankJson["customer"] {
                                self.customerDetails = Loan_Customer_list(json: customerModel)
                            }
                             
                            
                            self.tblView.reloadData()
                        }
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


extension BanksQuotesVC {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.BanksQuotesApi()
            }
            else {
                //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}




//MARK:-API data handling
 
class Bank_Quote_list:NSObject {
    
    //MARK: variable
    @objc var bank_code = ""
    @objc var message = ""
    @objc var bank_name = ""
    @objc var api_to_use = ""
    @objc var company_list = ""
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.bank_code = json["bank_code"].stringValue
        self.message = json["message"].stringValue
        self.bank_name = json["bank_name"].stringValue
        self.api_to_use = json["api_to_use"].stringValue
        self.company_list = json["company_list"].stringValue
        
    }
    
}

class Loan_Customer_list:NSObject, NSCoding {
    
   
   //MARK: variable
    
    var id = ""
    var reference_hash = ""
    var first_name = ""
    var middle_name = ""
    var last_name = ""
    var gender = ""
    var annual_income = ""
    var company_name = ""
    var date_of_birth = ""
    var company_type = ""
    var primary_bankaccount = ""
    var total_monthly_obligation = ""
    var city_name = ""
    var other_city_name = ""
    var occupation = ""
    var pagename = ""
    var email_id = ""
    var sep_details = ""
    var annual_turnover = ""
    var total_experience = ""
    var current_experience = ""
    var residence_status = ""
    var residence_pincode = ""
    var card_holder = ""
    var card_vintage = ""
    var is_loan_any = ""
    var emi_paid = ""
    var loan_amount = ""
    var date_created = ""
    var mobile_number = ""
    var residence_address = ""
    var pancard = ""
    var relationship_manager_id = ""
    var selected_banks = ""
       
//   //MARK: Lifecycle
    override init() {
        super.init()
    }
   
   
   /// Init method of model class
   ///
   /// - Parameter json: json object
   init(json : JSON) {
//       super.init()
    
    self.id = json["id"].stringValue
    self.reference_hash = json["reference_hash"].stringValue
    self.first_name = json["first_name"].stringValue
    self.middle_name = json["middle_name"].stringValue
    self.last_name = json["last_name"].stringValue
    self.gender = json["gender"].stringValue
    self.annual_income = json["annual_income"].stringValue
    self.company_name = json["company_name"].stringValue
    self.date_of_birth = json["date_of_birth"].stringValue
    self.company_type = json["company_type"].stringValue
    self.primary_bankaccount = json["primary_bankaccount"].stringValue
    self.total_monthly_obligation = json["total_monthly_obligation"].stringValue
    self.city_name = json["city_name"].stringValue
    self.other_city_name = json["other_city_name"].stringValue
    self.occupation = json["occupation"].stringValue
    self.pagename = json["pagename"].stringValue
    self.email_id = json["email_id"].stringValue
    self.sep_details = json["sep_details"].stringValue
    self.annual_turnover = json["annual_turnover"].stringValue
    self.total_experience = json["total_experience"].stringValue
    self.current_experience = json["current_experience"].stringValue
    self.residence_status = json["residence_status"].stringValue
    self.residence_pincode = json["residence_pincode"].stringValue
    self.card_holder = json["card_holder"].stringValue
    self.card_vintage = json["card_vintage"].stringValue
    self.is_loan_any = json["is_loan_any"].stringValue
    self.emi_paid = json["emi_paid"].stringValue
    self.loan_amount = json["loan_amount"].stringValue
    self.date_created = json["date_created"].stringValue
    self.mobile_number = json["mobile_number"].stringValue
    self.residence_address = json["residence_address"].stringValue
    self.pancard = json["pancard"].stringValue
    self.relationship_manager_id = json["relationship_manager_id"].stringValue
    self.selected_banks = json["selected_banks  "].stringValue
    
   }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.reference_hash = decoder.decodeObject(forKey: "reference_hash") as? String ?? ""
        self.first_name = decoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.middle_name = decoder.decodeObject(forKey: "middle_name") as? String ?? ""
        self.last_name = decoder.decodeObject(forKey: "last_name") as? String ?? ""
        self.gender = decoder.decodeObject(forKey: "gender") as? String ?? ""
        self.annual_income = decoder.decodeObject(forKey: "annual_income") as? String ?? ""
        self.company_name = decoder.decodeObject(forKey: "company_name") as? String ?? ""
        self.date_of_birth = decoder.decodeObject(forKey: "date_of_birth") as? String ?? ""
        self.company_type = decoder.decodeObject(forKey: "company_type") as? String ?? ""
        self.primary_bankaccount = decoder.decodeObject(forKey: "primary_bankaccount") as? String ?? ""
        self.total_monthly_obligation = decoder.decodeObject(forKey: "total_monthly_obligation") as? String ?? ""
        self.city_name = decoder.decodeObject(forKey: "city_name") as? String ?? ""
        self.other_city_name = decoder.decodeObject(forKey: "other_city_name") as? String ?? ""
        self.occupation = decoder.decodeObject(forKey: "occupation") as? String ?? ""
        self.pagename = decoder.decodeObject(forKey: "pagename") as? String ?? ""
        self.email_id = decoder.decodeObject(forKey: "email_id") as? String ?? ""
        self.sep_details = decoder.decodeObject(forKey: "sep_details") as? String ?? ""
        self.annual_turnover = decoder.decodeObject(forKey: "annual_turnover") as? String ?? ""
        self.total_experience = decoder.decodeObject(forKey: "total_experience") as? String ?? ""
        self.current_experience = decoder.decodeObject(forKey: "current_experience") as? String ?? ""
        self.residence_status = decoder.decodeObject(forKey: "residence_status") as? String ?? ""
        self.residence_pincode = decoder.decodeObject(forKey: "residence_pincode") as? String ?? ""
        self.card_holder = decoder.decodeObject(forKey: "card_holder") as? String ?? ""
        self.card_vintage = decoder.decodeObject(forKey: "card_vintage") as? String ?? ""
        self.is_loan_any = decoder.decodeObject(forKey: "is_loan_any") as? String ?? ""
        self.emi_paid = decoder.decodeObject(forKey: "emi_paid") as? String ?? ""
        self.loan_amount = decoder.decodeObject(forKey: "loan_amount") as? String ?? ""
        self.date_created = decoder.decodeObject(forKey: "date_created") as? String ?? ""
        self.mobile_number = decoder.decodeObject(forKey: "mobile_number") as? String ?? ""
        self.residence_address = decoder.decodeObject(forKey: "residence_address") as? String ?? ""
        self.pancard = decoder.decodeObject(forKey: "pancard") as? String ?? ""
        self.relationship_manager_id = decoder.decodeObject(forKey: "relationship_manager_id") as? String ?? ""
        self.selected_banks = decoder.decodeObject(forKey: "selected_banks") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode (id, forKey: "id")
        coder.encode (reference_hash, forKey: "reference_hash")
        coder.encode (first_name, forKey: "first_name")
        coder.encode (middle_name, forKey: "middle_name")
        coder.encode (last_name, forKey: "last_name")
        coder.encode (gender, forKey: "gender")
        coder.encode (annual_income, forKey: "annual_income")
        coder.encode (company_name, forKey: "company_name")
        coder.encode (date_of_birth, forKey: "date_of_birth")
        coder.encode (company_type, forKey: "company_type")
        coder.encode (primary_bankaccount, forKey: "primary_bankaccount")
        coder.encode (total_monthly_obligation, forKey: "total_monthly_obligation")
        coder.encode (city_name, forKey: "city_name")
        coder.encode (other_city_name, forKey: "other_city_name")
        coder.encode (occupation, forKey: "occupation")
        coder.encode (pagename, forKey: "pagename")
        coder.encode (email_id, forKey: "email_id")
        coder.encode (sep_details, forKey: "sep_details")
        coder.encode (annual_turnover, forKey: "annual_turnover")
        coder.encode (total_experience, forKey: "total_experience")
        coder.encode (current_experience, forKey: "current_experience")
        coder.encode (residence_status, forKey: "residence_status")
        coder.encode (residence_pincode, forKey: "residence_pincode")
        coder.encode (card_holder, forKey: "card_holder")
        coder.encode (card_vintage, forKey: "card_vintage")
        coder.encode (is_loan_any, forKey: "is_loan_any")
        coder.encode (emi_paid, forKey: "emi_paid")
        coder.encode (loan_amount, forKey: "loan_amount")
        coder.encode (date_created, forKey: "date_created")
        coder.encode (mobile_number, forKey: "mobile_number")
        coder.encode (residence_address, forKey: "residence_address")
        coder.encode (pancard, forKey: "pancard")
        coder.encode (relationship_manager_id, forKey: "relationship_manager_id")
        coder.encode (selected_banks, forKey: "selected_banks")
    }
   
}
 
