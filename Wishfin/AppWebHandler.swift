
//
//  AppWebHandler.swift
//  network
//
//  Created by Santosh on 23/05/17.
//  Copyright © 2017 vaibhav. All rights reserved.

//Abhishek

import UIKit
import Foundation

struct HeaderVariables {
    static let acceptVersion = "0.0.1"
    static let deviceOs = "ios"
}

class ImageDataDict {
    var imageData : Data
    var paramName : String
    
    init(data : Data, name : String) {
        imageData = data
        paramName = name
    }
}

enum HttpMethodType {
    case get // GET request
    case post // POST request
    case delete
    case put
}

class AppWebHandler : NSObject, URLSessionTaskDelegate {
    
    // Private URLSession object to handle all the network related calls.
    private var httpSession : URLSession?
    
    private var httpUploadSession : URLSession?
    
    typealias CompletionHandler = (_ data:Data?, _ dictionary:Dictionary<String, Any>?, _ statusCode:Int, _ error:Error?) -> ()
    
    //MARK: AppWebHandler Singleton Instance
    
    // Class object, which is lazily initiated when called first time. Only single instance resides through application life cycle.
    private static var instance : AppWebHandler = {
        let newInstance = AppWebHandler.init()
        return newInstance
    }()
    
    private override init() {
        super.init()
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        httpSession = URLSession.init(configuration: sessionConfiguration)
        
        httpUploadSession = URLSession.init(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    class func sharedInstance() -> AppWebHandler {
        return instance
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
          //Trust the certificate even if not valid
          let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

          completionHandler(.useCredential, urlCredential)
       }
    
    
    //MARK: API - Fetch data from specified url
    func fetchData(fromURL url:URL?, httpMethod:HttpMethodType, parameters:Dictionary<String,Any>?, shouldDeserialize deSerialize:Bool? = true, completionHandler:CompletionHandler?) -> Void {
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        guard let url1 = url else {
            assertionFailure("Url provided is invalid")
            return
        }
        
     //   // print("url = ", url1)
        
        let dataTask : URLSessionDataTask?
        var urlRequest : URLRequest?
        
        switch httpMethod {
            
        case .get:
            urlRequest = self.createGetRequest(withUrl: url1)
            break
            
        case .put:
            urlRequest = self.createPutRequest(withUrl: url1, andParameters: parameters)
            break
            
        case .delete:
            urlRequest = self.createDeleteRequest(withUrl: url1, andParameters: parameters)
            break
            
        default:
            urlRequest = self.createPostRequest(withUrl: url1, andParameters: parameters)
            break
        }
        
        
        urlRequest!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest!.addValue(HeaderVariables.acceptVersion, forHTTPHeaderField: "version")
        urlRequest!.addValue(HeaderVariables.deviceOs, forHTTPHeaderField: "os")
        
        dataTask = httpSession!.dataTask(with: urlRequest!, completionHandler: { (data, urlResponse, dataError) in
        
            DispatchQueue.main.async {
                
                // Checking for error, if there is any
                if dataError != nil {
                    // If there is error, then checking the condition if its error handling block is nil.
                    if completionHandler == nil {
                        return
                    }
                    else {
                        // User is posted with the error.
                        completionHandler!(nil,nil,0,dataError)
                        return
                    }
                }
                
                let statusCode = (urlResponse! as! HTTPURLResponse).statusCode
                
                // If no completion handler, then return.
                if completionHandler == nil {
                    return
                }
                
                if deSerialize! {
                    let string = String(data: data!, encoding: .utf8)
             //       print(string!)
                    
                    do {
                        let deSerializedDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                        //print(deSerializedDictionary)
                        
                        let responseDictionary = deSerializedDictionary
                     //   // print("status code = ", statusCode)
                       // // print("responseDictionary = ", responseDictionary)
                        
                        completionHandler!(nil,deSerializedDictionary,statusCode,nil)
                    
                        return
                    }
                    catch {
                        if completionHandler == nil {
                            return
                        }
                        else {
                            // User is posted with the error.
                            completionHandler!(nil,nil,statusCode,error)
                            return
                        }
                    }
                }
                else {
                    // Sending data and dictionary as nil object because 'deSerialize is FALSE'.
                    completionHandler!(data!,nil,statusCode,nil)
                    return
                }
            }
        })
        
        dataTask?.resume()
    }
    
    //MARK: API - Image + Parameters data
    func uploadImages(fromURL url:URL?, imagesArray:[ImageDataDict]?, otherParameters:Dictionary<String,Any>?, completionHandler:CompletionHandler?) -> Void {
        
        guard let url1 = url else {
            assertionFailure("Url provided is invalid")
            return
        }
        
        let dataTask : URLSessionDataTask?
        var urlRequest : URLRequest?
        
        urlRequest = createMultipleImageMultipartRequest(withUrl: url1, imageDataArray: imagesArray, andParameters: otherParameters)
        
        
        urlRequest!.addValue(HeaderVariables.acceptVersion, forHTTPHeaderField: "Accept-Version")
        urlRequest!.addValue(HeaderVariables.deviceOs, forHTTPHeaderField: "Device-Os")
        
        dataTask = httpSession!.dataTask(with: urlRequest!, completionHandler: { (data, urlResponse, dataError) in
            
            DispatchQueue.main.async {
                
                // Checking for error, if there is any
                if dataError != nil {
                    // If there is error, then checking the condition if its error handling block is nil.
                    if completionHandler == nil {
                        return
                    }
                    else {
                        // User is posted with the error.
                        completionHandler!(nil,nil,0,dataError)
                    }
                }
                
                let statusCode = (urlResponse! as! HTTPURLResponse).statusCode
                
                // If no completion handler, then return.
                if completionHandler == nil {
                    return
                }
                
                do {
                    let deSerializedDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                 //   print(deSerializedDictionary)
                    
                    completionHandler!(nil, deSerializedDictionary, statusCode, nil)
                }
                catch {
                    if completionHandler == nil {
                        return
                    }
                    else {
                        // User is posted with the error.
                        completionHandler!(nil,nil,statusCode,error)
                    }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    //MARK: - Private func - Create Get Request
    private func createGetRequest(withUrl url:URL) -> URLRequest {
        // Creating the base request with given url...
        var baseUrlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 40)
        
        // Setting http method as GET...
        baseUrlRequest.httpMethod = "GET"
        
        return baseUrlRequest
    }
    
    //MARK: - Private func - Create Post Request
    private func createPostRequest(withUrl url:URL, andParameters parameters:Dictionary<String,Any>?) -> URLRequest {
        // Creating the base request with given url...
        var baseUrlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 40)
        
        // Setting http method as POST...
        baseUrlRequest.httpMethod = "POST"
        
        // Gaurding the parameters Dictionary(also unwraps) and handling the invalid(else condition). If parameters Dictionary is empty or nil, then returning the base request...
        guard let params = parameters else {
          //  // print("Parameter dictionary is invalid")
            return baseUrlRequest
        }
        
        // Checking whether the Dictionary is returning the valid Json string...
        let isValidJson = JSONSerialization.isValidJSONObject(params)
        
        // Guarding the Bool and checking for True else AssertionFailure with message. Can not proceed further
        guard isValidJson else {
            assertionFailure("Parameter dictionary is invalid - \n\(params)")
            return baseUrlRequest
        }
        
        // Optional Data variable to hold the request post data...
        var postData : Data?
        
        // Do-Catch syntax to handle the Dictionary to Json string conversion. Here we are force unwrapping try because we are sure the object will return proper Json string...
        do {
            postData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        // Setting base request http body
        baseUrlRequest.httpBody = postData!
        
        return baseUrlRequest
    }
    
    //MARK: - Private func - Create Post Request
    private func createPutRequest(withUrl url:URL, andParameters parameters:Dictionary<String,Any>?) -> URLRequest {
        
        // Creating the base request with given url...
        var baseUrlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 40)
        
        // Setting http method as POST...
        baseUrlRequest.httpMethod = "PUT"
        
        // Gaurding the parameters Dictionary(also unwraps) and handling the invalid(else condition). If parameters Dictionary is empty or nil, then returning the base request...
        guard let params = parameters else {
          //  // print("Parameter dictionary is invalid")
            return baseUrlRequest
        }
        
        // Checking whether the Dictionary is returning the valid Json string...
        let isValidJson = JSONSerialization.isValidJSONObject(params)
        
        // Guarding the Bool and checking for True else AssertionFailure with message. Can not proceed further
        guard isValidJson else {
            assertionFailure("Parameter dictionary is invalid - \n\(params)")
            return baseUrlRequest
        }
        
        // Optional Data variable to hold the request post data...
        var postData : Data?
        
        // Do-Catch syntax to handle the Dictionary to Json string conversion. Here we are force unwrapping try because we are sure the object will return proper Json string...
        do {
            postData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        // Setting base request http body
        baseUrlRequest.httpBody = postData!
        
        return baseUrlRequest
    }
    
    //MARK: - Private func - Create Post Request
    private func createDeleteRequest(withUrl url:URL, andParameters parameters:Dictionary<String,Any>?) -> URLRequest {
        
        // Creating the base request with given url...
        var baseUrlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 40)
        
        // Setting http method as POST...
        baseUrlRequest.httpMethod = "DELETE"
        
        // Gaurding the parameters Dictionary(also unwraps) and handling the invalid(else condition). If parameters Dictionary is empty or nil, then returning the base request...
        guard let params = parameters else {
           // // print("Parameter dictionary is invalid")
            return baseUrlRequest
        }
        
        // Checking whether the Dictionary is returning the valid Json string...
        let isValidJson = JSONSerialization.isValidJSONObject(params)
        
        // Guarding the Bool and checking for True else AssertionFailure with message. Can not proceed further
        guard isValidJson else {
            assertionFailure("Parameter dictionary is invalid - \n\(params)")
            return baseUrlRequest
        }
        
        // Optional Data variable to hold the request post data...
        var postData : Data?
        
        // Do-Catch syntax to handle the Dictionary to Json string conversion. Here we are force unwrapping try because we are sure the object will return proper Json string...
        do {
            postData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        
        // Setting base request http body
        baseUrlRequest.httpBody = postData!
        
        return baseUrlRequest
    }
    
    //MARK: - Private func - Create Multipart Post Request
    private func createMultipleImageMultipartRequest(withUrl url:URL, imageDataArray:[ImageDataDict]?, andParameters parameters:Dictionary<String,Any>?) -> URLRequest {
        
        let boundary = String(format: "Boundary+%08X%08X", arc4random(), arc4random())
        let contentType = String(format: "multipart/form-data; boundary=%@", boundary)
        
        // Creating the base request with given url...
        var baseUrlRequest = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 40)
        
        // Setting http method as POST...
        baseUrlRequest.httpMethod = "POST"
        
        baseUrlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        if imageDataArray != nil {
            for item in imageDataArray! {
                body.append(String(format:"\r\n--%@\r\n",boundary).data(using: .utf8)!)
                
                let string1 = String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", item.paramName, item.paramName)
                
                body.append(string1.data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(item.imageData)
            }
        }
        
        if parameters != nil {
            for (key,value) in parameters! {
                body.append(String(format:"\r\n--%@\r\n",boundary).data(using: .utf8)!)
                
                if let newValue = value as? [String:Any] {
                    let string1 = String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, self.createJSONString(usingDictionary: newValue) as CVarArg)
                    body.append(string1.data(using: .utf8)!)
                }
                else {
                    let string1 = String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value as! CVarArg)
                    body.append(string1.data(using: .utf8)!)
                }
            }
        }
        
        body.append(String(format:"\r\n--%@--\r\n",boundary).data(using: .utf8)!)
        
        // Setting base request http body
        baseUrlRequest.httpBody = body
        
        return baseUrlRequest
    }
    
    //MARK:-
    func createJSONString(usingDictionary dictionary : Dictionary<String,Any>) -> String {
        
        // Checking whether the Dictionary is returning the valid Json string...
        let isValidJson = JSONSerialization.isValidJSONObject(dictionary)
        
        // Guarding the Bool and checking for True else AssertionFailure with message. Can not proceed further
        guard isValidJson else {
            assertionFailure("Parameter dictionary is invalid - \n\(dictionary)")
            return ""
        }
        
        // Optional Data variable to hold the request post data...
        var postData : Data?
        var postString : String?
        
        // Do-Catch syntax to handle the Dictionary to Json string conversion. Here we are force unwrapping try because we are sure the object will return proper Json string...
        do {
            postData = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            postString = String.init(data: postData!, encoding: .utf8)
        }
        
        return postString!
    }
    
    //MARK:-
    func cancelTask(forEndpoint endpoint:String) -> Void {
        httpSession?.getAllTasks(completionHandler: { (taskArray) in
            for task in taskArray {
                if let originalRequest = task.originalRequest {
                    if (originalRequest.url?.absoluteString.contains(endpoint))! {
                        task.cancel()
                        return
                    }
                }
            }
        })
    }
}
