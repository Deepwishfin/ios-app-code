//
//  Constants.swift
//  Wishfin
//
//  Created by Wishfin on 15/05/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Identifier
struct Identifier {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
}

// MARK:- Screen Sizes
struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}

//MARK:- Regex
struct Regex {
    static let mobileNumberRegex = "^[6-9]\\d{9}$"
}

// MARK:- Colour
struct Color {
    static let primaryColor = "#00BDAA"
}

//MARK: - URL
struct UrlName {
    
    // Production Server
 static let baseUrl = "https://api.wishfin.com/"
    // stage Server
//   static let baseUrl = "https://apipreprod.wishfin.com/" // "https://apistage.wishfin.com/"
     
    static let oAuth = "oauth"
    static let checkEmailMobile = "check-mobile-email-exist"
    static let getOtp = "v1/get-otp-data"
    static let login = "v1/login"
    static let updateLastLogin = "update-last-login"
    static let otpVerify = "v1/otp-verify"
    static let signup = "v1/signup"
    
    static let cibilFulfillOrder = "v1/cibil-fulfill-order"
    static let getCibilUserDetail = "v1/get-cibil-user-detail?"
    static let getDashboardCibitFactor = "get-cibil-credit-factors/"
    static let getCibitFactor = "get-cibil-credit-factors?"
    static let activeDeals = "v1/mtuzo-deal-claimed?"
    static let expiredDeals = "v2/mtuzo-deal-claimed?"
    static let cardUpdate = "v1/mtuzo-cart-cards"
    static let historyScore = "historic-score?"
    static let saveDeal = "mtuzo-deal-claimed"
  
    static let personalLoan = "personal-loan?"
    static let personalLoanContinue = "personal-loan-continue"
    static let getquotepersonalLoan = "v1/personal-loan-get-quote/"
    static let personalLoanSelectBank = "select-opted-bank"
    
    /*
     
     /v1/personal-loan-get-quote/(use saved id)

     /select-opted-bank
     
     */
    
    
    static let pp = "page-setting-detail?page_name=privacy-policy"
    static let terms = "page-setting-detail?page_name=terms-and-conditions"
    static let termSignup = "page-setting-detail?page_name=cibil-terms-and-conditions"

    static let onTimePayment = "on_time_payment"
    static let hardEnq = "hard_inquiries"
    static let creditUtilse = "credit_utilization"
    static let loan = "credit_mix"
    static let creditAge = "credit_age"
    static let getDetail = "v1/get-cibil-detail-info-loan-cc?"
     
    static let cibilVerifyAns = "v1/cibil-verify-answers"
    static let cibilAuthQue = "v1/cibil-authentication-questions/"
    static let cibilCustomerAsset = "v1/cibil-customer-assets"
    
    static let getCardCodesApi = "api/v4/offers/find?"
    
}

struct offerURLname {
    
    // Offers Server
    static let offers_baseUrl = "https://mtuzo.net/api/v4/offers/find?"
    //static string
    static let actionStr = "action=get_card_codes&"
    static let clientkey = "clientkey=82671367055317111838&"
    static let clientpass = "clientpass=80025757200127830400&"
    static let apikey = "apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&"
   
    static let iso = "viso=in"
    
    static let nearME_baseUrl = "https://mtuzo.net/api/v4/offers/find?action=offers_near_me&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=0&count=50&iso=in"
    
    static let OnlineOffer_baseUrl = "https://mtuzo.net/api/v4/offers/find?action=online_offers&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=0&count=5&iso=in"
    
    static let OnlineOfferDetails_baseUrl = "https://mtuzo.net/api/v4/offers/find?action=online_offer_detail&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=2&count=6&iso=in"
    
    static let OflineOfferDetails_baseUrl = "https://mtuzo.net/api/v4/offers/find?action=offer_detail&clientkey=82671367055317111838&clientpass=80025757200127830400&apikey=2zo9iwktpFjfHjue531o43xiMnEQQIVThk2zQm3g2mvJG0YM4Za83IqP54GW&startid=0&count=6&iso=in"
    
    static let googleAPI_Url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyB7VMdQa2vz7lEA5MspwxM1C51Bd043_mQ&components=country:in&input="
    
    static let latLngAPI_Url = "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyB7VMdQa2vz7lEA5MspwxM1C51Bd043_mQ&address="
    
    //AIzaSyBf7RtmvCXhKKpXf-jsSKqNhBWXE7wY8qY    --- old google key
}
 
// MARK:- Web Service Params
struct APIField {
    static let headerKey = "Bearer "
    static let securityTokenKey = "securityToken"
}

// MARK: - User Defaults
struct DefaultsKey {
    static let isAlreadyLogin = "isAlreadyLogin"
    static let isAlreadyLaunched = "isAlreadyLaunched"
    static let accessToken = "access_token"
    static let loginDetails = "loginDetails"
    static let loginType = "loginType"
    static let cibilId = "cibilId"
    static let cibilScore = "cibilScore"
    static let fetchDate = "fetchDate"
    static let unlockCard = "unlockCard"
    static let abhiListCard = "abhiListCard" 
}

// MARK: - AlertField Names
struct AlertField {
    static let NA = "N/A"
    static let emptyfNameString = "Enter First Name"
    static let emptylNameString = "Enter Last Name"
    static let invalidfNameString = "Enter valid First Name"
    static let invalidmNameString = "Enter valid Middle Name"
    static let invalidlNameString = "Enter valid Last Name"
    static let emptDobString = "Please select your date of birth."
    static let emptyPanString = "Please enter your pan card number."
    static let invalidPanString = "Enter Valid PAN"
    static let emptyEmailString = "Please enter your email address"
    static let validMobileString = "Enter valid mobile number"
    static let emptyOtpString = "Please enter otp number"
    static let digitMobileString = "Enter 10 Digits Mobile Number"
    static let emptyStateString = "Please select state first"
    static let emptyCityString = "Please select city first"
    static let emptySchoolString = "Please select school first"
    static let invalidEmailString = "Enter Valid Email id"
    static let acceptTnC = "please accept terms and conditions."
    static let okString = "Ok"
    static let loaderString = "Loading"
    static let noInternetString = "Seems like your internet services are disabled, please go to Settings and turn on Internet Services."
    static let oopsString = "OOPS!!!"
    static let retry = "Retry"
}
