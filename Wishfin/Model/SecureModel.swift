//
//  SecureModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 24/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class SecureModel: NSObject {
    
    //MARK: variable
    @objc var account_id = ""
    @objc var member_name = ""
    @objc var icon = ""
    @objc var account_type = ""
    @objc var date_opened = ""
    @objc var is_active = ""
    @objc var percent_completed = ""
    
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
        self.icon = json["icon"].stringValue
        self.account_type = json["account_type"].stringValue
        self.date_opened = json["date_opened"].stringValue
        self.is_active = json["is_active"].stringValue
        self.percent_completed = json["percent_completed"].stringValue
    }
}
//Class ends here
