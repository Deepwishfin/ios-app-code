//
//  SelectCardViewController.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import Alamofire

typealias cardCodeString = (_ cardId:String) -> ()

class SelectCardViewController: UIViewController {
    
    var cardCodeDelegate:cardCodeString?
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgWebView: UIWebView!
    @IBOutlet weak var trapentView: UIView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var carNameBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBOutlet weak var visaView: UIView!
    @IBOutlet weak var masterCardView: UIView!
    @IBOutlet weak var americanExpView: UIView!
    @IBOutlet weak var rupayView: UIView!
    @IBOutlet weak var mestroView: UIView!
    @IBOutlet weak var dinnerClubView: UIView!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var tfCardType: UITextField!
    
    //   @IBOutlet weak var tableSelectCard: UITableView!
    @IBOutlet weak var tableCardType: UITableView!
    
    @IBOutlet weak var nextBtn:UIButton!
    
    //MARK: - Variables
    var creditCardArray = [CreditUtiliseModel]()
    var cardTypeArray = [CardTypeModel]()
    var selectCard = [CreditUtiliseModel]()
    var str_CardType = ""
    var str_BankCode = ""
    
    var str_CardCode = ""
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: "13.0") {
            backBtn.isHidden = true
        } else {
            backBtn.isHidden = false
            self.view.backgroundColor = .black
        }
        
        
        tfCardType!.setLeftPaddingPoints(8)
        tfCardType!.setRightPaddingPoints(28)
        
        
        self.tableCardType!.tableFooterView = UIView()
        self.tableCardType.register(UINib.init(nibName: CardTypeCell.className(), bundle: nil), forCellReuseIdentifier: CardTypeCell.className())
        self.tableCardType!.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        str_CardType = "2"
        str_BankCode = creditCardArray[0].bank_code
        selectCard = [self.creditCardArray[0]]
        
        self.setupView()
        self.cardsApi(cardType: str_CardType, bankCode: str_BankCode)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.trapentView!.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Setting up View
    func setupView() {
        
        self.MakeAllViewReset()
        visaView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
        visaView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        
        bankNameLabel.text = creditCardArray[0].member_name
        accountLabel.text = creditCardArray[0].account_number
        cardNameLabel.text = " Which card is this of " + creditCardArray[0].member_name
        loadWebView(url: creditCardArray[0].icon)
        imgWebView.layer.borderWidth = 1.0
        imgWebView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imgWebView.layer.cornerRadius = 10.0
        imgWebView.layer.masksToBounds = true
        
    }
    
    func loadWebView(url:String) {
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        self.cardsUpdateApi()
    }
    
    
    @IBAction func changeCardBtnClicked(_ sender: Any) {
        //  self.tableSelectCard!.isHidden = false
        self.tableCardType!.isHidden = true
        self.nextBtn.isHidden = false
    }
    
    
    @IBAction func selectCardTypeBtnClicked(_ sender: Any) {
        
        let btn:UIButton = sender as! UIButton
        print(btn.tag)
        self.MakeAllViewReset()
        str_CardType = String(btn.tag)
        switch btn.tag {
        case 1:
            masterCardView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            masterCardView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        case 2:
            visaView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            visaView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        case 3:
            americanExpView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            americanExpView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        case 4:
            rupayView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            rupayView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        case 8:
            mestroView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            mestroView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        case 9:
            dinnerClubView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 1)
            dinnerClubView.layer.backgroundColor = #colorLiteral(red: 0.8393854499, green: 0.9662141204, blue: 0.9568769336, alpha: 1)
        default:
            return
        }
        self.cardsApi(cardType: self.str_CardType, bankCode: self.str_BankCode)
    }
    
    func MakeAllViewReset() {
        
        visaView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        visaView.layer.borderWidth = 1.0
        visaView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
        
        masterCardView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        masterCardView.layer.borderWidth = 1.0
        masterCardView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
        
        americanExpView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        americanExpView.layer.borderWidth = 1.0
        americanExpView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
        
        rupayView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        rupayView.layer.borderWidth = 1.0
        rupayView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
        
        mestroView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        mestroView.layer.borderWidth = 1.0
        mestroView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
        
        dinnerClubView.layer.borderColor = #colorLiteral(red: 0.3233533502, green: 0.7423834205, blue: 0.6692049503, alpha: 0)
        dinnerClubView.layer.borderWidth = 1.0
        dinnerClubView.layer.backgroundColor = #colorLiteral(red: 0.9715235829, green: 0.9877577424, blue: 0.9910820127, alpha: 1)
    }
    
    @IBAction func Action_CardType(_ sender: Any) {
        
        if cardTypeArray.count > 0 { 
            self.tableCardType!.isHidden = false
            self.nextBtn.isHidden = true
            //   self.tableSelectCard!.isHidden = true
        }
    }
    
    
}

//MARK: Get Api call
extension SelectCardViewController {
    func cardsApi(cardType:String, bankCode:String) {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            self.cardTypeArray.removeAll()
            self.tableCardType!.isHidden = true
            self.nextBtn.isHidden = false
            
            let firstUrl = offerURLname.offers_baseUrl + offerURLname.actionStr + offerURLname.clientkey + offerURLname.clientpass + offerURLname.apikey + offerURLname.iso
            let secondUrl = "&bank_code=\(bankCode)&card_type=1&network=\(cardType)"
            
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
            
            //             let getUrl = "https://mtuzo.net/api/v4/offers/find?action=get_card_codes&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&bank_code=NEMqKCKBiSgl3vWM8wED&network=2&card_type=1&iso=in"
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.arrayValue
                    
                    self.cardTypeArray.removeAll()
                    
                    if responseArray!.count > 0 {
                        for country in responseArray! {
                            self.cardTypeArray.append(CardTypeModel(json: country))
                        }
                        self.tableCardType!.reloadData()
                        print( self.cardTypeArray)
                        self.tfCardType.text = self.cardTypeArray[0].cardName
                        self.str_CardCode = self.cardTypeArray[0].cardCode
                        self.nextBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.6666666667, alpha: 1)
                        self.nextBtn.isUserInteractionEnabled = true
                        
                        
                    } else {
                        self.tfCardType.text = "No Card Available"
                        self.nextBtn.backgroundColor = #colorLiteral(red: 0.7411106229, green: 0.7412186265, blue: 0.7410870194, alpha: 1)
                        self.nextBtn.isUserInteractionEnabled = false
                    } 
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
    
    func cardsUpdateApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.cardUpdate
            let dict = selectCard[0]
            let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId)
            let headers = ["Authorization": Defaults.getHeader()]
            
            
            var card_network_code = "Visa"
             
            if str_CardType == "2" {
                card_network_code = "Visa"
            } else if str_CardType == "1" {
                card_network_code = "Master"
            } else if str_CardType == "3" {
                card_network_code = "American Express"
            } else if str_CardType == "4" {
                card_network_code = "Rupay"
            } else if str_CardType == "8" {
                card_network_code = "Maestro"
            } else if str_CardType == "9" {
                card_network_code = "Diners Club"
            }
            
            
            
            var params = ["master_user_id":masterUserId,
                          "mf_user_id": mfUserId,
                          "cibil_id": "\(cibilId!)",
                          "bank_name_code":dict.cart_statusNew.bank_name_code ,
                          "is_cibil": "1",
                          "card_network":self.str_CardType,
                          "bank_name":dict.cart_statusNew.bank_name,
                          "card_network_code":card_network_code,
                          "card_name":self.str_CardCode,
                          "card_type":dict.cart_statusNew.card_type,
                          "card_type_code": "Credit Card"]
//            card_name_code ---
//            credit_card_account_number  ---
            var card_name_code = tfCardType.text ?? ""
            
            if !dict.cart_status.isEmpty {
                
                let myValue = dict.cart_status
                card_name_code = tfCardType.text ?? "".removeOptional(myStr: "\(String(describing: myValue["card_name_code"]))")
                let credit_card_account_number = "".removeOptional(myStr: "\(String(describing: myValue["credit_card_account_number"]))")
                let id = "".removeOptional(myStr: "\(String(describing: myValue["id"]))")
                
                
                params = ["master_user_id":masterUserId,
                              "mf_user_id": mfUserId,
                              "cibil_id": "\(cibilId!)",
                              "bank_name_code":dict.cart_statusNew.bank_name_code ,
                              "is_cibil": "1",
                              "card_network":self.str_CardType,
                              "bank_name":dict.cart_statusNew.bank_name,
                              "card_network_code":card_network_code,
                              "card_name":self.str_CardCode,
                              "card_type":dict.cart_statusNew.card_type,
                              "card_type_code": "Credit Card",
                              "card_name_code": card_name_code,
                              "credit_card_account_number":credit_card_account_number,
                              "id":id]
            }
            
            
            print(params)
             
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: firstUrl, method: .post, parameters: params, completionHandler: { (json, status) in
                
                self.dismissHUD(isAnimated: true)
                
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                self.cardCodeDelegate?(self.str_CardCode)
                
                var myArr = Defaults.getCardListAbhi()
                
                if myArr.count >= 1 {
                    
                    let cardCode = self.selectCard[0].account_number
                    
                    for index in 0...(myArr.count - 1) {
                        let list_cardCode = myArr[index]["cardCode"]
                        if cardCode == list_cardCode {
                            let cardDic = ["cardCode": cardCode,
                                           "card_name_code": card_name_code,
                                           "card_network_code": card_network_code]
                            myArr.remove(at: index)
                            myArr.insert(cardDic, at: index)
                        }
                    }
                    
                    Defaults.setCardListAbhi(myArr)
                    
                }
                
                 
                Switcher.updateRootVC(SelIndex: 3)
            })
            
            
        }else{
            self.showNoIntAlert()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                // Handle Error
            }
        }
        return nil
    }
    
    
}

extension SelectCardViewController {
    func showNoIntAlert() {
        let alert = UIAlertController(title: AlertField.oopsString, message: AlertField.noInternetString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertField.retry,style: .default,handler: {(_: UIAlertAction!) in
            if NetworkManager.sharedInstance.isInternetAvailable(){
                self.cardsApi(cardType: self.str_CardType, bankCode: self.str_BankCode)
            }
            else {
                //  self.showNoIntAlert()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}



// MARK: - Tableview Methods
extension SelectCardViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tableCardType == tableView) {
            return self.cardTypeArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTypeCell.className(), for: indexPath) as! CardTypeCell
        cell.title_Cell!.text = cardTypeArray[indexPath.row].cardName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tfCardType.text = cardTypeArray[indexPath.row].cardName
        str_CardCode = cardTypeArray[indexPath.row].cardCode
        
        
        tableView.isHidden = true
        self.nextBtn.isHidden = false
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
