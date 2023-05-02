//
//  PaymentStatusModel.swift
//  ApptiveLearn
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import Foundation
import SwiftyJSON

class PaymentStatusModel :NSObject {
    
    //MARK: Variable
    @objc var total_payments = 0
    @objc var on_time_paymentse = 0
    @objc var statusArray = [PStatusModel]()

    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.total_payments = json["total_payments"].intValue
        self.on_time_paymentse = json["on_time_paymentse"].intValue
        if let responseArray = json["payments"].arrayObject {
            for model in responseArray{
                let dict = JSON(model)
                 self.statusArray.append(PStatusModel(json: dict))
            }
          
        }
    }
}
//Class ends here
