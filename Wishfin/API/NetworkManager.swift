//
//  NetworkManager.swift
//  Wishfin
//  Created by Wishfin on 14/06/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

public class NetworkManager {
    
    //MARK: Variable declaration
    static let sharedInstance = NetworkManager()
    
    let sessionManager: SessionManager = {
      let configuration = URLSessionConfiguration.background(withIdentifier: "com.mywish.wishfin")
      configuration.timeoutIntervalForRequest = 10
      return SessionManager(configuration: configuration)
    }()

    
    //MARK:- Check Internet Connectivity
    func isInternetAvailable() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK:- Common Network Service Call with header
    func commonNetworkCallWithHeader(header :[String:String],url:String,method:HTTPMethod,parameters : [String:Any]?,completionHandler:@escaping (JSON?,String?)->Void) {
        sessionManager.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch (response.result) {
             case .success:
                 if(response.result.isSuccess){
                     if let data = response.result.value{
                         let json = JSON(data)
                         completionHandler(json,nil)
                         return
                     }
                 }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                completionHandler(nil,"Request timeout")
                    return
                }
            }
            completionHandler(nil,response.result.error?.localizedDescription)
        }
    }
}




//Class ends here
