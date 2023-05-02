//
//  DetailsModel.swift
//  ApptiveLearn
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Vedvyas Rauniyar. All rights reserved.
//

import Foundation
import SwiftyJSON

class DetailsModel: NSObject {
    
    //MARK: variable
    @objc var status = PaymentStatusModel()
    @objc var account_detail_id = "N/A"
    @objc var account_number = ""
    @objc var account_type = ""
    @objc var actual_payment_amount = ""
    @objc var amount_overdue = ""
    @objc var cash_limit = ""
    @objc var completed_percentage = 0
    @objc var credit_limit = ""
    @objc var current_balance = ""
    @objc var date_of_last_payment = ""
    @objc var date_opened = ""
    @objc var date_reported_certified = ""
    @objc var emi_amount = ""
    @objc var expected_completion_date = ""
    @objc var icon = ""
    @objc var member_name = ""
    @objc var ownership = ""
    @objc var paid_amount = ""
    @objc var payment_due = ""
    @objc var payment_frequency = ""
    @objc var payment_start_date = ""
    @objc var payment_status = ""
    @objc var rate_of_interest = ""
    @objc var repayment_tenure = ""
    @objc var sanctioned_amount = ""
    @objc var settlement_amount = ""
    @objc var suit_filed = ""
    @objc var type_collateral = ""
    @objc var utilization_percentage = 0
    @objc var value_collateral = ""
    @objc var written_principal_amount = ""
    @objc var written_status = ""
    @objc var written_total_amount = ""
    
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
     self.status = PaymentStatusModel(json: json["payment_status"])
     self.account_detail_id = json["account_detail_id"].stringValue
     self.account_number = json["account_number"].stringValue
     self.account_type = json["account_type"].stringValue
     self.actual_payment_amount = json["actual_payment_amount"].stringValue
     self.amount_overdue = json["amount_overdue"].stringValue
     self.cash_limit = json["cash_limit"].stringValue
     self.completed_percentage = json["completed_percentage"].intValue
     self.credit_limit = json["credit_limit"].stringValue
     self.current_balance = json["current_balance"].stringValue
     self.date_of_last_payment = json["date_of_last_payment"].stringValue
     self.date_opened = json["date_opened"].stringValue
     self.date_reported_certified = json["date_reported_certified"].stringValue
     self.emi_amount = json["emi_amount"].stringValue
     self.expected_completion_date = json["expected_completion_date"].stringValue
     self.icon = json["icon"].stringValue
     self.member_name = json["member_name"].stringValue
     self.ownership = json["ownership"].stringValue
     self.paid_amount = json["paid_amount"].stringValue
     self.payment_due = json["payment_due"].stringValue
     self.payment_frequency = json["payment_frequency"].stringValue
     self.payment_start_date = json["payment_start_date"].stringValue
     self.payment_status = json["payment_status"].stringValue
     self.rate_of_interest = json["rate_of_interest"].stringValue
     self.repayment_tenure = json["repayment_tenure"].stringValue
     self.sanctioned_amount = json["sanctioned_amount"].stringValue
     self.settlement_amount = json["settlement_amount"].stringValue
     self.suit_filed = json["suit_filed"].stringValue
     self.type_collateral = json["type_collateral"].stringValue
     self.utilization_percentage = json["utilization_percentage"].intValue
     self.value_collateral = json["value_collateral"].stringValue
     self.written_principal_amount = json["written_principal_amount"].stringValue
     self.written_status = json["written_status"].stringValue
     self.written_total_amount = json["written_total_amount"].stringValue
    }
}
//Class ends here
