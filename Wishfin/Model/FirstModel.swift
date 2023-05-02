//
//  FirstModel.swift
//  ApptiveLearn
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Vedvyas Rauniyar. All rights reserved.
//

import Foundation
import SwiftyJSON

class FirstModel: NSObject {
    
    //MARK: variable
    @objc var city_name = ""
    @objc var state_code = ""
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.city_name = json["city_name"].stringValue
        self.state_code = json["state_code"].stringValue
    }
}
//Class ends here
