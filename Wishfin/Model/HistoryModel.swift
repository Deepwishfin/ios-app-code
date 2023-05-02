//
//  HistoryModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 24/11/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class HistoryModel: NSObject {
    
    //MARK: variable
    @objc var cibil_id = ""
    @objc var cibilScore = 0
    @objc var id = 0
    var dateModel = DateModel()
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.cibil_id = json["cibil_id"].stringValue
        self.cibilScore = json["cibilScore"].intValue
        self.id = json["id"].intValue
        self.dateModel = DateModel(json: json["cibilScoreFetchDate"])
    }
}

struct DateModel {
    //MARK: variable
     var timezone = ""
     var timezone_type = 0
     var date = ""
    
    
    //MARK: Lifecycle
     init() {
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        self.timezone = json["timezone"].stringValue
        self.timezone_type = json["timezone_type"].intValue
        self.date = json["date"].stringValue
    }
}
//Class ends here
