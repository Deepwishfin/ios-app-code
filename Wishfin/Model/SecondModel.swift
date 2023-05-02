//
//  SecondModel.swift
//  ApptiveLearn
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Vedvyas Rauniyar. All rights reserved.
//

import Foundation
import SwiftyJSON

class SecondModel: NSObject {
    
    //MARK: variable
    @objc var account_id = ""
    @objc var member_name = ""
    @objc var sanctioned_amount = ""
    @objc var current_balance = ""
    @objc var credit_utilize = ""
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
        self.account_id = json["account_id"].stringValue
        self.member_name = json["member_name"].stringValue
        self.sanctioned_amount = json["sanctioned_amount"].stringValue
        self.current_balance = json["current_balance"].stringValue
        self.credit_utilize = json["credit_utilize"].stringValue
        self.icon = json["icon"].stringValue
    }
}
//Class ends here
