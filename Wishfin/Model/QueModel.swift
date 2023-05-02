//
//  QueModel.swift
//  Wishfin
//
//  Created by Vedvyas Rauniyar on 24/12/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import SwiftyJSON

class QueModel: NSObject {
    
    //MARK: variable
    @objc var LastChanceQuestion = ""
    @objc var FullQuestionText = ""
    @objc var Key = ""
    var ansArray = [AnsModel]()
    
    //MARK: Lifecycle
    override init() {
        super.init()
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        super.init()
        self.LastChanceQuestion = json["LastChanceQuestion"].stringValue
        self.FullQuestionText = json["FullQuestionText"].stringValue
        self.Key = json["Key"].stringValue
        if let responseArray = json["AnswerChoice"].arrayObject {
            for model in responseArray{
                let dict = JSON(model)
                self.ansArray.append(AnsModel(json: dict))
            }
            
        }
    }
}

struct AnsModel {
   
    //MARK: variable
    var AnswerChoiceText = ""
    var Key = ""
    var AnswerChoiceId = ""
    
    //MARK: Lifecycle
    init() {
    }
    
    /// Init method of model class
    ///
    /// - Parameter json: json object
    init(json : JSON) {
        self.AnswerChoiceText = json["AnswerChoiceText"].stringValue
        self.Key = json["Key"].stringValue
        self.AnswerChoiceId = json["AnswerChoiceId"].stringValue
    }
}
//Class ends here
