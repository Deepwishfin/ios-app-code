//
//  CardCollectionCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 27/10/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit
import SDWebImage

class CardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cardTypeImg: UIImageView!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var planTypeLbl: UILabel!
     @IBOutlet weak var cardEditBtn: UIButton!
      @IBOutlet weak var imgWebView: UIWebView!
    
    var MainViewContr = UIViewController()
    var CreditUtilise = [CreditUtiliseModel]()
     
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 12
        self.mainView.layer.masksToBounds = true
        // Initialization code
    }

    func cardDataShow(dict:CreditUtiliseModel,viewContr:UIViewController, indexPath: Int)
    {

        CreditUtilise = [dict]
        self.bankNameLbl.text = dict.member_name
         self.planTypeLbl.text = dict.cart_statusNew.card_name_code
        
        let myArr = Defaults.getCardListAbhi()
        
        if myArr.count >= 1 {
            
            let cardCode = dict.account_number
            
            for item in myArr {
                let list_cardCode = item["cardCode"]
                if cardCode == list_cardCode {
                    self.planTypeLbl.text = item["card_name_code"]
                    
                    let card_network_code = item["card_network_code"]
                    
                    if card_network_code == "Visa" {
                        cardTypeImg.image = UIImage(named: "visaCard")
                    } else if card_network_code == "Master" {
                        cardTypeImg.image = UIImage(named: "masterCard")
                    } else if card_network_code == "American Express" {
                        cardTypeImg.image = UIImage(named: "americanExpCard")
                    } else if card_network_code == "Rupay" {
                        cardTypeImg.image = UIImage(named: "rupayCard")
                    } else if card_network_code == "Maestro" {
                        cardTypeImg.image = UIImage(named: "mestroCard")
                    } else if card_network_code == "Diners Club" {
                        cardTypeImg.image = UIImage(named: "dinnerClubCard")
                    }
                   
                }
            }
           
        }
        
       
        self.MainViewContr = viewContr
         loadWebView(url: dict.icon)
    }
    
    func loadWebView(url:String){
        if let url = URL(string: url){
            let requestObj = URLRequest(url: url)
            imgWebView.loadRequest(requestObj)
        }
    }

}
