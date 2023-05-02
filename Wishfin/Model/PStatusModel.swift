//
//  PStatusModel.swift
//  ApptiveLearn
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Ratna Sagar. All rights reserved.
//

import Foundation
import SwiftyJSON

class PStatusModel :NSObject {
    
    //MARK: Variable
    @objc var days = ""
    @objc var month = ""
    @objc var year = ""
    
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: Json object
    init(json : JSON) {
        self.days = json["days"].stringValue
        self.month = json["month"].stringValue
        self.year = json["year"].stringValue
    }
}
//Class ends here
