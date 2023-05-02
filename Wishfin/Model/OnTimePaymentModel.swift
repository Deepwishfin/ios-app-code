//
//  OnTimePaymentModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class OnTimePaymentModel: NSObject {
    
    //MARK: variable
    @objc var missed_payment_count = ""
    @objc var name = ""
    @objc var member_name = ""
    @objc var account_id = ""
    @objc var icon = ""
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.missed_payment_count = json["missed_payment_count"].stringValue
        self.name = json["name"].stringValue
        self.account_id = json["account_id"].stringValue
        self.member_name = json["member_name"].stringValue
        self.icon = json["icon"].stringValue
    }
}
//Class ends here
