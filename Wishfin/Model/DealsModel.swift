//
//  DealsModel.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 17/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class DealsModel: NSObject {
    
    //MARK: variable
    @objc var outletName = ""
    @objc var outletCode = ""
    @objc var imgUrl = ""
    @objc var offerCode = ""
    @objc var highlight = ""
    @objc var expiryDate = ""
    @objc var outletDistance = ""
     
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.outletName = json["outlet_name"].stringValue
        self.outletCode = json["outlet_code"].stringValue
        self.imgUrl = json["img_url"].stringValue
        self.offerCode = json["offer_code"].stringValue
        self.highlight = json["highlight"].stringValue
        self.expiryDate = json["expiry_date"].stringValue
        self.outletDistance = json["outlet_distance"].stringValue
         
    }
}
