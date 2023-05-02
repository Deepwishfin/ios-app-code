//
//  CreditUtiliseModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class activeDealsModel: NSObject {
    
    //MARK: variable
    @objc var offer_highlights = ""
    @objc var bank_name = ""
    @objc var website_url = ""
    @objc var id = ""
    @objc var tnc = ""
    @objc var longitude = ""
    @objc var date_created = ""
    @objc var network_name = ""
    @objc var icon = ""
    @objc var cc_card_name = ""
    @objc var outletimage_url = ""
    @objc var mobile_number = ""
    @objc var cc_card_code = ""
    @objc var offer_code = ""
    @objc var card_type_code = ""
    @objc var bank_code = ""
    @objc var brand_code = ""
    @objc var card_type = ""
    @objc var offer_type = ""
    @objc var cibil_id = ""
    @objc var outlet_name = ""
    @objc var network_type = ""
    @objc var coupon_code = ""
    @objc var latitude = ""
    @objc var expire_date = ""


    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.offer_highlights = json["offer_highlights"].stringValue
     self.bank_name = json["bank_name"].stringValue
        self.website_url = json["website_url"].stringValue
        self.id = json["id"].stringValue
        self.tnc = json["tnc"].stringValue
        self.longitude = json["longitude"].stringValue
        self.date_created = json["date_created"].stringValue
        self.network_name = json["network_name"].stringValue
        self.icon = json["icon"].stringValue
        self.cc_card_name = json["cc_card_name"].stringValue
        self.outletimage_url = json["outletimage_url"].stringValue
        self.mobile_number = json["mobile_number"].stringValue
        self.cc_card_code = json["cc_card_code"].stringValue
        self.offer_code = json["offer_code"].stringValue
        self.card_type_code = json["card_type_code"].stringValue
        self.bank_code = json["bank_code"].stringValue
        self.brand_code = json["brand_code"].stringValue
        self.card_type = json["card_type"].stringValue
      self.offer_type = json["offer_type"].stringValue
       
        self.cibil_id = json["cibil_id"].stringValue
        self.outlet_name = json["outlet_name"].stringValue
        self.network_type = json["network_type"].stringValue
        self.coupon_code = json["coupon_code"].stringValue
        self.latitude = json["latitude"].stringValue
        self.expire_date = json["expire_date"].stringValue

    }
}
//Class ends here
