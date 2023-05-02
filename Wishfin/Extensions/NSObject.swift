//
//  NSObject.swift
//  Wishfin
//
//  Created by Wishfin on 14/6/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    /// Get class name string
    ///
    /// - Returns: name of class
    class func className() -> String {
        return String(describing: self)
    }
    
    func primaryColor() -> UIColor {
        return  UIColor(red: 0/255.0, green: 189/255.0, blue: 170/255.0, alpha: 1.0)
    }
    
    class func accurateRound(value: Double) -> Int {
        let d : Double = value - Double(Int(value))
        if d < 0.5 {
            return Int(value)
        } else {
            return Int(value) + 1
        }
    }
    
    /// Check for valid contact
    func isMobileNumberValid(mobileNumberData : String) -> Bool {
        let mobileNumberTest = NSPredicate(format: "SELF MATCHES %@", Regex.mobileNumberRegex)
        let mobileNumberResult = mobileNumberTest.evaluate(with: mobileNumberData)
        return mobileNumberResult
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func isfNameValid(name : String) -> Bool{
        let regularExpression = "^[a-zA-Z]{2,15}$"
        let nameValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        return nameValidation.evaluate(with: name)
    }
    
    func ismNameValid(name : String) -> Bool{
        let regularExpression = "^[a-zA-Z]{0,10}$"
        let nameValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        return nameValidation.evaluate(with: name)
    }
    
    func isPancardValid(pannumber : String) -> Bool{
        let regularExpression = "[A-Z]{3}[P]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}"
        let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
        return panCardValidation.evaluate(with: pannumber)
    }
    
    func checkOTPValidity(otpData: String)-> Bool{
        if(otpData.isEmpty) {
            return false
        } else if (otpData.count != 4){
            return false
        } else {
            return true
        }
    }
    
    func getDate(toDate:String)->Date{
        let dateString = toDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return Date()
        }
        return date
    }
    
    func convertDate(toDate:String)->String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let datePrint = DateFormatter()
        datePrint.dateFormat = "dd MMM yyyy"
        if let date = dateFormatterGet.date(from: toDate) {
            return datePrint.string(from: date)
        }
        return ""
    }
    
    func getIPAddress() -> String {
        var addresses = [String]()
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "192.168.1.223" }
        guard let firstAddr = ifaddr else { return "192.168.1.223" }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        if addresses.count >= 2 {
            return addresses[2]
        }
        else {
            return "192.168.1.223"
        }
    }
}


extension UIImage {
    func createSelectionIndicator(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        CommonMethods.hexStringToUIColor(hex: "00BDAA").setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: 2.0))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
//Class ends here
