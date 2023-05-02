//
//  Defaults.swift
//  Wishfin
//
//  Created by Wishfin on 19/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class Defaults: NSObject {
    
    static let userDefaults = UserDefaults.standard
   
    static func setCardListAbhi(_ myArr:[[String:String]])  {
        let data = NSKeyedArchiver.archivedData(withRootObject: myArr)
        userDefaults.set(data, forKey: DefaultsKey.abhiListCard)
    }
    
    static func getCardListAbhi() -> [[String:String]] {
      
        if let data = userDefaults.value(forKey: DefaultsKey.abhiListCard) as? Data {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:String]] {
                   print(dict)
                return dict
             }
        }
        
        return []
    }
     
    
    
    
    
    static func setCardUnlock(_ value: Bool)  {
        userDefaults.set(value, forKey: DefaultsKey.unlockCard)
    }
    
    static func getCardUnlock() -> Bool {
      return userDefaults.bool(forKey: DefaultsKey.unlockCard)
    }
    
    static func setLaunched(_ value: Bool)  {
        userDefaults.set(value, forKey: DefaultsKey.isAlreadyLaunched)
    }
    
    static func getLaunched() -> Bool {
      return userDefaults.bool(forKey: DefaultsKey.isAlreadyLaunched)
    }
    
    static func setSession(_ value: Bool)  {
        userDefaults.set(value, forKey: DefaultsKey.isAlreadyLogin)
    }
    
    static func getSession() -> Bool {
        return userDefaults.bool(forKey: DefaultsKey.isAlreadyLogin)
    }
    
    static func setAccessToken(_ accessToken: String)  {
        userDefaults.set(accessToken, forKey: DefaultsKey.accessToken)
    }
   
    static func getAccessToken() -> String? {
        if let accessToken = userDefaults.string(forKey: DefaultsKey.accessToken) {
            return accessToken
        } else {
            return ""
        }
    }
    
    static func getHeader()-> String {
        var header = ""
        if let token = getAccessToken(){
             header = APIField.headerKey + token
        }
        return header
    }
   
    static func setSecurityToken(_ securityToken: String)  {
        userDefaults.set(securityToken, forKey: APIField.securityTokenKey)
    }
    
    static func removeSecurityToken()  {
        userDefaults.removeObject(forKey: APIField.securityTokenKey)
    }
    
    static func getSecurityToken() -> String? {
        if let securityToken = userDefaults.string(forKey: APIField.securityTokenKey) {
            return securityToken
        } else {
            return "" 
        }
    }
    
    static func resetData(){
        userDefaults.removeObject(forKey: DefaultsKey.accessToken)
        userDefaults.removeObject(forKey: APIField.securityTokenKey)
    }
}

