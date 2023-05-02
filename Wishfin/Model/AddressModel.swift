//
//  AddressModel.swift
//  Wishfin
//
//  Created by Abhishek Mishra on 03/04/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddressModel : NSObject {
    
    //MARK: variable
    @objc var descriptionStr = ""
    @objc var id = ""
    @objc var place_id = ""
    
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        
        self.descriptionStr = json["description"].stringValue
        self.id = json["id"].stringValue
        self.place_id = json["place_id"].stringValue
        /*
        {
           "description": "Delhi, India",
           "id": "9e280bae198a170435c5dff3faa5ef5e29328bc8",
           "matched_substrings": [
              {
                 "length": 5,
                 "offset": 0
              }
           ],
           "place_id": "ChIJL_P_CXMEDTkRw0ZdG-0GVvw",
           "reference": "ChIJL_P_CXMEDTkRw0ZdG-0GVvw",
           "structured_formatting": {
              "main_text": "Delhi",
              "main_text_matched_substrings": [
                 {
                    "length": 5,
                    "offset": 0
                 }
              ],
              "secondary_text": "India"
           },
           "terms": [
              {
                 "offset": 0,
                 "value": "Delhi"
              },
              {
                 "offset": 7,
                 "value": "India"
              }
           ],
           "types": [
              "locality",
              "political",
              "geocode"
           ]
        }
        */
    }
}

