//
//  CommonMethods.swift
//  Wishfin
//
//  Created by Wishfin on 14/6/19..
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

@objc class CommonMethods: NSObject {

    /// Get Random Color
    ///
    /// - Returns: random Color
    class func getRandomColor() -> UIColor {
        return UIColor.init(red: (CGFloat(arc4random_uniform(255))/255.0), green: (CGFloat(arc4random_uniform(255))/255.0), blue: (CGFloat(arc4random_uniform(255))/255.0), alpha: 1)
    }
    
    /// Get symbol from Text
    /// - Parameter name: name for which text symbol is to be generated
    /// - Returns: text symbol
    class func getTextSymbols(from name: String) -> String {
        
        // Trimming extra white spaces and dividing Name on the basis of " "
        let arrayOfNameSubParts = name.trimmingCharacters(in: NSCharacterSet.whitespaces).components(separatedBy: " ")
        if (arrayOfNameSubParts.count > 0) {
            
            // Get Initial Letters from Name(which are separated by space)
            var logoString = ""
            
            // If Name is having only one subpart, then show starting two letters of that part
            if (arrayOfNameSubParts.count == 1) {
                let initialTwoLetters = name.prefix(1)
                logoString += initialTwoLetters.uppercased()
            }else {
                
                // If Name is having more than one subpart, then show starting one letter of initial two subparts
                for (index, substrings) in arrayOfNameSubParts.enumerated() {
                    logoString += String.init(describing: substrings.first!).uppercased()
                    if (index == 1) {
                        break
                    }
                }
            }
            return logoString
        }
        return ""
    }
   
    
    /* This is a function that takes a hex string and returns a UIColor.
     (You can enter hex strings with either format: #ffffff or ffffff)
     Usage: var color1 = hexStringToUIColor("#d3d3d3") */
    /// - Parameter hex: Hex String
    /// - Returns: The Value of UIColor
  class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}

extension Date {
    
    var timeStamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
//Class ends here



