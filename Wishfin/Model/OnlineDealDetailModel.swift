//
//  OnlineDealDetailModel.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 20/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class OnlineDealDetailModel : NSObject {
    
    //MARK: variable
    @objc var offerDescription = ""
    @objc var highlight = ""
    @objc var expiryDate = ""
    @objc var imgUrl = ""
    @objc var brandUrl = ""
    @objc var brandName = ""
    @objc var tnc = ""
    @objc var coupon = ""
    @objc var validOnDesc = ""
    @objc var offerUrl = ""
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        
        self.offerDescription = json["offer_description"].stringValue
        self.highlight = json["highlight"].stringValue
        self.expiryDate = json["expiry_date"].stringValue
        self.imgUrl = json["img_url"].stringValue
        self.brandUrl = json["brand_url"].stringValue
        self.brandName = json["brand_name"].stringValue
        self.tnc = json["tnc"].stringValue
        self.coupon = json["coupon"].stringValue
        self.validOnDesc = json["valid_on_desc"].stringValue
        self.offerUrl = json["offer_url"].stringValue
         
    }
}
 
