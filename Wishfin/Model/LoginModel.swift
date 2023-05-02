//
//  LoginModel.swift
//  Everywherebycar
//
//  Created by Vedvyas Rauniyar on 12/11/19.
//  Copyright © 2019 EqualInfotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginModel: NSObject,NSCoding {
    
    var email_id = ""
    var date_of_birth = ""
    var signup_source = ""
    var last_name = ""
    var middle_name = ""
    var first_name = ""
    var is_invest_ready = ""
    var master_user_id = ""
    var mf_user_id = ""
    var mobile_number = ""
    var profile_image_name = ""
    var pancard = ""
    var last_login = ""
    
    override init() {
        super.init()
    }
    
    init(json : JSON) {
        self.email_id = json["email_id"].stringValue
        self.date_of_birth = json["date_of_birth"].stringValue
        self.signup_source = json["signup_source"].stringValue
        self.last_name = json["last_name"].stringValue
        self.middle_name = json["middle_name"].stringValue
        self.first_name = json["first_name"].stringValue
        self.is_invest_ready = json["is_invest_ready"].stringValue
        self.master_user_id = json["master_user_id"].stringValue
        self.mf_user_id = json["mf_user_id"].stringValue
        self.mobile_number = json["mobile_number"].stringValue
        self.profile_image_name = json["profile_image_name"].stringValue
        self.pancard = json["pancard"].stringValue
        self.last_login = json["last_login"].stringValue
    }
    
    required init(coder decoder: NSCoder) {
        self.email_id = decoder.decodeObject(forKey: "email_id") as? String ?? ""
        self.date_of_birth = decoder.decodeObject(forKey: "date_of_birth") as? String ?? ""
        self.signup_source = decoder.decodeObject(forKey: "signup_source") as? String ?? ""
        self.last_name = decoder.decodeObject(forKey: "last_name") as? String ?? ""
        self.middle_name = decoder.decodeObject(forKey: "middle_name") as? String ?? ""
        self.first_name = decoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.is_invest_ready = decoder.decodeObject(forKey: "is_invest_ready") as? String ?? ""
        self.master_user_id = decoder.decodeObject(forKey: "master_user_id") as? String ?? ""
        self.mf_user_id = decoder.decodeObject(forKey: "mf_user_id") as? String ?? ""
        self.mobile_number = decoder.decodeObject(forKey: "mobile_number") as? String ?? ""
        self.profile_image_name = decoder.decodeObject(forKey: "profile_image_name") as? String ?? ""
        self.pancard = decoder.decodeObject(forKey: "pancard") as? String ?? ""
        self.last_login = decoder.decodeObject(forKey: "last_login") as? String ?? ""
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode (email_id, forKey: "email_id")
        coder.encode (date_of_birth, forKey: "date_of_birth")
        coder.encode (signup_source, forKey: "signup_source")
        coder.encode (last_name, forKey: "last_name")
        coder.encode (middle_name, forKey: "middle_name")
        coder.encode (first_name, forKey: "first_name")
        coder.encode (is_invest_ready, forKey: "is_invest_ready")
        coder.encode (master_user_id, forKey: "master_user_id")
        coder.encode (mf_user_id, forKey: "mf_user_id")
        coder.encode (mobile_number, forKey: "mobile_number")
        coder.encode (profile_image_name, forKey: "profile_image_name")
        coder.encode (pancard, forKey: "pancard")
        coder.encode (last_login, forKey: "last_login")
    }
}


struct UserProfileCache {
    static let key = "userProfileCache"
    static func save(_ value: Profile!) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> Profile! {
        var userData: Profile!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode(Profile.self, from: data)
            return userData!
        } else {
            return userData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}


struct Profile: Codable {
    let correspondence_city: String
    let cibil_id: String
    let pancard: String
    let email_id: String
    let occupation: String
    let last_name: String
    let annual_income: String
    let correspondence_state: String
    let mobile_number: String
    let gender: String
    let cibil_score: String
    let cibil_score_fetch_date: String
    let first_name: String
    let date_of_birth: String
    let correspondence_address: String
    let correspondence_pincode: String
    
}
