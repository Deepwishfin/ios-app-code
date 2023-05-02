//
//  InquiryModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class InquiryModel: NSObject {
    
    //MARK: variable
    @objc var member_name = ""
    @objc var enquiry_amount = ""
    @objc var YEAR = ""
    @objc var id = ""
    @objc var date_of_enquiry = ""
    @objc var icon = ""
    @objc var enquiry_purpose = ""
   
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.member_name = json["member_name"].stringValue
        self.enquiry_amount = json["enquiry_amount"].stringValue
        self.YEAR = json["YEAR"].stringValue
        self.id = json["id"].stringValue
        self.date_of_enquiry = json["date_of_enquiry"].stringValue
        self.icon = json["icon"].stringValue
        self.enquiry_purpose = json["enquiry_purpose"].stringValue
    }
}
//Class ends here
