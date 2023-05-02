//
//  CardTypeModel.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 16/03/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardTypeModel: NSObject {
    
    //MARK: variable
    @objc var cardCode = ""
    @objc var cardName = ""
  
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.cardCode = json["card_code"].stringValue
        self.cardName = json["card_name"].stringValue
    }
}
 
