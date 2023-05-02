//
//  DealDetailsVC.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 08/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import ExpandableLabel

class DealDetailsVC: UIViewController, ExpandableLabelDelegate {
      
    @IBOutlet weak var img_Title: UIImageView!
    
    @IBOutlet weak var scr_View: UIScrollView!
    @IBOutlet weak var view_Content: UIView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_DIscountPercent: UILabel!
    
    @IBOutlet weak var lbl_valid: UILabel!
    @IBOutlet weak var lbl_DetailValid: UILabel!
    
    @IBOutlet weak var lbl_TandC: UILabel!
    
    @IBOutlet weak var lbl_DetailTandC: ExpandableLabel!
     
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_DetailAddress: UILabel!
    
    @IBOutlet weak var mapView: UIImageView!
    
    @IBOutlet weak var btn_GetDirection: UIButton!
    
    
    var isOnlineDeal:Bool = false
    
    var userLatitude = ""
    var userLongitude = ""
    var offerCode = ""
    var brandCode = ""
    var webURL = ""
    var expire_date = ""
    var tnc = ""
    var outletimage_url = ""
    var brandUrl = ""
    
    var dealsOfflineArrayDetails = [DealsModel]()
    var dealsOnlineArrayDetails = [OnlineDealDetailModel]()
    
    var selectCard = [CreditUtiliseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

     //   scr_View.isScrollEnabled = true
        //OnlineDealVC
        
        lbl_Title.text = ""
        lbl_DIscountPercent.text = ""
        lbl_valid.text = ""
        lbl_DetailValid.text = ""
        lbl_TandC.text = ""
        lbl_DetailTandC.text = ""
        lbl_Address.text = ""
        lbl_DetailAddress.text = ""
         
        if isOnlineDeal == true {
            self.deals_Online_Api()
        } else {
            self.deals_Offline_Api()
        }
        
        lbl_DetailTandC.delegate = self
        lbl_DetailTandC.collapsedAttributedLink = NSAttributedString(string: "Read More")
        lbl_DetailTandC.expandedAttributedLink = NSAttributedString(string: "Read Less")
        lbl_DetailTandC.ellipsis = NSAttributedString(string: "...")
        lbl_DetailTandC.collapsed = true
        lbl_DetailTandC.numberOfLines = 3
        lbl_DetailTandC.shouldCollapse = true
        
        scr_View.updateContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {

         self.hidesBottomBarWhenPushed = true
        
        if selectCard.count == 0 && cardListArrayAbhi.count >= 1 {
            for item in cardListArrayAbhi {
                
                print(item) 
                
//                if <#condition#> {
//                    <#code#>
//                }
            }
        }
        
        
    }
 
 
    @IBAction func Action_Back(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Action_GetDirection(_ sender: Any) {
//        let obj = OnlineDealVC.init(nibName: OnlineDealVC.className(), bundle: nil)
//        obj.hidesBottomBarWhenPushed = true
//        obj.strTemp_CardCode = str_CardCode
//        self.navigationController?.pushViewController(obj, animated: true)
        
        if (UIApplication.shared.canOpenURL(URL(string: "maps://")!)) {
               //do whatever you need to do here.
            UIApplication.shared.open(URL(string:
                "http://maps.apple.com/?daddr=\(userLatitude),\(userLongitude)")!, options: [:], completionHandler: nil)
        }
        else if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?center=\(userLatitude),\(userLongitude)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://");
            UtilityClass.showAlertWithTitle(message: "some error occurred", onViewController: self, withButtonArray: nil, dismissHandler: nil)
        }
    }
    
    @IBAction func Action_GetDeal(_ sender: Any) {
         
        saveDealApi()
       /*
//        print(view.makeSnapshot() as Any)
//        let myImage: UIImage? = UIImage(snapshotOf: view)
        if isOnlineDeal == true {
            let obj = OnlineDealVC.init(nibName: OnlineDealVC.className(), bundle: nil)
            obj.hidesBottomBarWhenPushed = true
            obj.strOfferCode = offerCode
            obj.strWebURL = webURL
            
            self.present(obj, animated: true, completion: nil)
           // self.navigationController?.pushViewController(obj, animated: true)
        } else {
            let obj = OfflineDealVC.init(nibName: OfflineDealVC.className(), bundle: nil)
            obj.hidesBottomBarWhenPushed = true
            obj.outletLat = userLatitude
            obj.outletLng = userLongitude
            self.present(obj, animated: true, completion: nil)
                      }
 */
    }
    
    
    func saveDealApi() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")
            
            let firstUrl = UrlName.baseUrl + UrlName.saveDeal
            
            let cibilId = UserDefaults.standard.value(forKey: DefaultsKey.cibilId)
            let dict = selectCard[0]
            
            let headers = ["Authorization": Defaults.getHeader()]
            
            guard let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails) else {
                return
            }
            
            guard let loginModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel else {
                return
            }
            
            var dealType = "Offline_offer"
            if isOnlineDeal == true {
                dealType = "Online_offer"

            }
            
            let params = ["cibil_id": "".removeOptional(myStr: "\(cibilId ?? "")"),
                          "mobile_number": "".removeOptional(myStr: "\(loginModel.mobile_number)"),
                          "bank_code": "".removeOptional(myStr: "\(dict.cart_statusNew.bank_name_code)"),
                          "bank_name": "".removeOptional(myStr: "\(dict.cart_statusNew.bank_name)"),
                          "cc_card_name": "".removeOptional(myStr: "\(dict.cart_statusNew.card_name)"),
                          "cc_card_code": "".removeOptional(myStr: "\(dict.cart_statusNew.card_name_code)"),
                          "offer_code": "".removeOptional(myStr: "\(offerCode)"),
                          "network_name": "".removeOptional(myStr: "\(dict.cart_statusNew.card_network)"),
                          "network_type": "".removeOptional(myStr: "\(dict.cart_statusNew.card_network_code)"),
                          "latitude": "".removeOptional(myStr: "\(userLatitude)"),
                          "longitude": "".removeOptional(myStr: "\(userLongitude)"),
                          "outlet_name": "".removeOptional(myStr: "\(String(describing: lbl_Title.text))"),
                          "offer_type": "".removeOptional(myStr: "\(dealType)"),
                          "offer_highlights": "".removeOptional(myStr: "\(String(describing: lbl_DIscountPercent.text))"),
                          "coupon_code": "".removeOptional(myStr: "\(offerCode)"),
                          "website_url": "".removeOptional(myStr: "\(webURL)"),
                          "brand_code": "".removeOptional(myStr: "\(brandCode)"),
                          "expire_date": "".removeOptional(myStr: "\(expire_date)"),
                          "tnc": "".removeOptional(myStr: "\(tnc)"),
                          "outletimage_url": "".removeOptional(myStr: "\(outletimage_url)")]
             
                  
            print(params)
             
            
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: firstUrl, method: .post, parameters: params, completionHandler: { (json, status) in
                
                self.dismissHUD(isAnimated: true)
                
                guard let jsonValue = json?.dictionaryValue else {
                    return
                }
                print(jsonValue)
                
                if self.isOnlineDeal == true {
                    let obj = OnlineDealVC.init(nibName: OnlineDealVC.className(), bundle: nil)
                    obj.hidesBottomBarWhenPushed = true
                    obj.strOfferCode = self.offerCode
                    obj.strWebURL = self.webURL
                    
                    self.present(obj, animated: true, completion: nil)
                } else {
                    let obj = OfflineDealVC.init(nibName: OfflineDealVC.className(), bundle: nil)
                    obj.hidesBottomBarWhenPushed = true
                    obj.outletLat = self.userLatitude
                    obj.outletLng = self.userLongitude
                    self.present(obj, animated: true, completion: nil)
                }
                
            })
            
            
        }else{
            self.showNoIntAlert()
        }
    }
    

    func willExpandLabel(_ label: ExpandableLabel) {
        scr_View.updateContentView()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
//        lbl_DetailTandC.collapsed = false
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        scr_View.updateContentView()
        scr_View.setContentOffset(.zero, animated: true) 
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
    }
    
}

extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

        if (bolAfterLabel) {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)

            self.attributedText = mutableAttachmentString
        }
    }

    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

 
//MARK: Get Api call
extension DealDetailsVC {
    func deals_Offline_Api() {
        if NetworkManager.sharedInstance.isInternetAvailable(){
            self.showHUD(progressLabel: "Loading...")

            let firstUrl = offerURLname.OflineOfferDetails_baseUrl
            let secondUrl = "&user_latitude=\(userLatitude)&user_longitude=\(userLongitude)&offer_code=\(offerCode)&outlet_code=\(brandCode)"
             
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
 
            // let getUrl = "https://mtuzo.net/api/v4/offers/find?action=offer_detail&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&user_latitude=17.384962&user_longitude=78.487405&startid=0&count=6&offer_code=SZqGuzWfNTwIIbcVmpAw&outlet_code=bKTgDidunjeVfbaWAgSy&iso=in"

            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }

                print(jsonValue)
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.dictionaryValue
                    
                    let urlString:String = responseArray?["img_url"]?.string ?? ""// model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let Imageurl = URL(string: urlString)!
                    self.img_Title.af_setImage(withURL: Imageurl)
                    
                    self.lbl_Title.text = responseArray?["outlet_name"]?.string ?? ""
                    self.lbl_DIscountPercent.text = responseArray?["offer_description"]?.string ?? ""
                    self.lbl_DIscountPercent.addImage(imageName: "offers", afterLabel: false)
                    self.lbl_valid.text = "Valid On"
                    self.lbl_DetailValid.text = responseArray?["valid_on_desc"]?.string ?? ""
                    self.lbl_TandC.text = "Terms & Conditions"
                    
//                    self.lbl_DetailTandC.text = responseArray?["tnc"]?.string ?? ""
                    
                    let fPoint = responseArray?["expiry_date"]?.string ?? ""
                    let sPoint = responseArray?["tnc"]?.string ?? ""
                    
                    if fPoint == "" {
                        self.lbl_DetailTandC.text = responseArray?["tnc"]?.string ?? ""
                    } else {
                        self.lbl_DetailTandC.text = "1. This offer is valid till \(fPoint). \n2. \(sPoint)"
                    }
                    
                    
                    
                    
                    
                    self.lbl_Address.text = "Address"
                    self.lbl_DetailAddress.text = responseArray?["outlet_address"]?.string ?? ""
                    
                    
                    let latfloat = responseArray?["outlet_latitude"]?.float
                    let lngfloat = responseArray?["outlet_longitude"]?.float
                    
                    self.userLatitude = latfloat?.description ?? "0.0"
                    self.userLongitude = lngfloat?.description ?? "0.0"
                    
                  //  self.mapView.isHidden = false
                    self.btn_GetDirection.isHidden = false
                    
                       
                    self.expire_date = responseArray?["expiry_date"]?.string ?? ""
                    self.tnc = responseArray?["tnc"]?.string ?? ""
                    self.outletimage_url = responseArray?["img_url"]?.string ?? ""
                    
                    self.scr_View.updateContentView()
                    
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
            
            let firstUrl = offerURLname.OnlineOfferDetails_baseUrl
            let secondUrl = "&user_latitude=\(userLatitude)&user_longitude=\(userLongitude)&offer_code=\(offerCode)&brand_code=\(brandCode)"
             
            let getUrl = firstUrl + secondUrl
            let headers = ["Authorization": Defaults.getHeader()]
              
            // https://mtuzo.net/api/v4/offers/find?action=online_offer_detail&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=2&count=6&iso=in
             
            NetworkManager.sharedInstance.commonNetworkCallWithHeader(header: headers, url: getUrl, method: .get, parameters: nil, completionHandler: { (json, status) in
                guard let jsonValue = json?.dictionaryValue else {
                    self.dismissHUD(isAnimated: true)
                    self.showNoIntAlert()
                    return
                }
                
                print(jsonValue)
                if jsonValue["success"]?.boolValue ?? false == true {
                    
                    let responseArray = jsonValue["response"]?.dictionaryValue
                      
                    let urlString:String = responseArray?["img_url"]?.string ?? ""// model.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let Imageurl = URL(string: urlString)!
                        self.img_Title.af_setImage(withURL: Imageurl)
                        
                        self.lbl_Title.text = responseArray?["brand_name"]?.string ?? ""
                        self.lbl_DIscountPercent.text = responseArray?["offer_description"]?.string ?? ""
                        self.lbl_DIscountPercent.addImage(imageName: "offers", afterLabel: false)
                        self.lbl_valid.text = "Highlights"
                        self.lbl_DetailValid.text = responseArray?["highlight"]?.string ?? ""
                        self.lbl_TandC.text = "Terms & Conditions"
                    
                    let fPoint = responseArray?["expiry_date"]?.string ?? ""
                    let sPoint = responseArray?["tnc"]?.string ?? ""
                    
                    if fPoint == "" {
                        self.lbl_DetailTandC.text = responseArray?["tnc"]?.string ?? ""
                    } else {
                        self.lbl_DetailTandC.text = "1. This offer is valid till \(fPoint). \n2. \(sPoint)"
                    }
                    
                        
                        self.lbl_Address.text = "Offer Url"
                        self.lbl_DetailAddress.text = responseArray?["offer_url"]?.string ?? ""
                          
                    self.webURL = responseArray?["brand_url"]?.string ?? ""
                    
                   // self.mapView.isHidden = true
                    self.btn_GetDirection.isHidden = true
                    self.mapView.isHidden = true
                    
                    self.view_Content.updateConstraints()
                    
                 //   self.scr_View.contentSize = CGSize(width: self.scr_View.frame.width, height: ( self.view_Content.frame.height + 50))
                    
                       
                    self.expire_date = responseArray?["expiry_date"]?.string ?? ""
                    self.tnc = responseArray?["tnc"]?.string ?? ""
                    self.outletimage_url = responseArray?["img_url"]?.string ?? ""
                    
                     
                }
                self.dismissHUD(isAnimated: true)
            })
        }else{
            self.showNoIntAlert()
        }
    }
}


extension DealDetailsVC {
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


extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}

extension UIImage {
    convenience init?(snapshotOf view: UIView) {
        guard let image = view.makeSnapshot(), let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}



extension String {
    func removeOptional(myStr:String) -> String {
        let newStr = myStr.replacingOccurrences(of: "Optional(", with: "")
        let newStr2 = newStr.replacingOccurrences(of: ")", with: "")
        return newStr2
    }
    
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
