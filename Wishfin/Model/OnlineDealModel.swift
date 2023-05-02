
//
//  OnlineDealModel.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 20/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class OnlineDealModel: NSObject {
    
    //MARK: variable
    @objc var offercode = ""
    @objc var outletDistance = ""
    @objc var brandCode = ""
    @objc var brandUrl = ""
    @objc var imgUrl = ""
    @objc var highlight = ""
    @objc var brandName = ""
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        
        self.offercode = json["offercode"].stringValue
        self.outletDistance = json["outlet_distance"].stringValue
        self.brandCode = json["brand_code"].stringValue
        self.brandUrl = json["brand_url"].stringValue
        self.imgUrl = json["img_url"].stringValue
        self.highlight = json["highlight"].stringValue
        self.brandName = json["brand_name"].stringValue
         
    }
}
