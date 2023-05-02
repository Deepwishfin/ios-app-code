//
//  CreditUtiliseModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 23/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreditUtiliseModel: NSObject {
    
    //MARK: variable
    @objc var credit_utilize = ""
    @objc var sanctioned_amount = ""
    @objc var account_id = ""
    @objc var member_name = ""
    @objc var current_balance = ""
    @objc var icon = ""
    @objc var credit_limit = ""
    @objc var bank_code = ""
    @objc var account_number = ""
    @objc var cart_status:[String:Any] = [:]
    
    var cart_statusNew = cart_statusData()
   
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.credit_utilize = json["credit_utilize"].stringValue
        self.sanctioned_amount = json["sanctioned_amount"].stringValue
        self.account_id = json["account_id"].stringValue
        self.member_name = json["member_name"].stringValue
        self.current_balance = json["current_balance"].stringValue
        self.icon = json["icon"].stringValue
        self.credit_limit = json["credit_limit"].stringValue
        self.bank_code = json["bank_code"].stringValue
        self.account_number = json["account_number"].stringValue
        self.cart_status = json["cart_status"].dictionary!
        self.cart_statusNew = cart_statusData(json: json["cart_status"])

    }
}
//Class ends here

struct cart_statusData {
    //MARK: variable
     var bank_name_code = ""
    var card_type_code = ""
    var is_cibil = ""
    var card_name = ""
    var credit_card_account_number = ""
    var card_network_code = ""
    var bank_name = ""
    var mf_user_id = ""
    var card_type = ""
    var cibil_id = ""
    var master_user_id = ""
    var card_network = ""
    var id = ""
    var card_name_code = ""
 
    //MARK: Lifecycle
     init() {
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        print(json)
        self.bank_name_code = json["bank_name_code"].stringValue
          self.card_type_code = json["card_type_code"].stringValue
          self.is_cibil = json["is_cibil"].stringValue
          self.card_name = json["card_name"].stringValue
          self.credit_card_account_number = json["credit_card_account_number"].stringValue
          self.card_network_code = json["card_network_code"].stringValue
          self.bank_name = json["bank_name"].stringValue
          self.mf_user_id = ""
          self.card_type = json["card_type"].stringValue
          self.cibil_id = json["cibil_id"].stringValue
          self.master_user_id = ""
          self.card_network = json["card_network"].stringValue
        self.id = json["id"].stringValue
        self.card_name_code = json["card_name_code"].stringValue

    }
}
