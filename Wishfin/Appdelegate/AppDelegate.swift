//
//  AppDelegate.swift
//  Wishfin
//
//  Created by Wishfin on 09/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import IQKeyboardManagerSwift

var ScaleFactorX = UIScreen.main.bounds.size.width/375
var screenWidth: CGFloat = UIScreen.main.bounds.size.width
var screenHeight: CGFloat = UIScreen.main.bounds.size.height
var  masterUserId = ""
var  mfUserId = ""
let userDefaults = UserDefaults.standard
 
var cardListArrayAbhi = [CreditUtiliseModel]()


@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var remoteConfig: RemoteConfig!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        FirebaseApp.configure()
        initialSetup()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate {
    /// Setting the initial data
    func initialSetup(){
        loadInitialWebView()
        IQKeyboardManager.shared.enable = true
        firebaseSetup()
        checkIfAlreadyLogin()
    }
    
    /// If user is already logged in
    func checkIfAlreadyLogin() {
        Switcher.updateRootVC(SelIndex: 0)
    }
    
    /// Initialise the webview very first time
    func loadInitialWebView() {
        var dummyWebView : UIWebView? = UIWebView(frame: UIScreen.main.bounds)
        let htmlString = "<!doctype html><html lang=en><head><meta charset=utf-8><title>dummy</title></head><body><p>dummy content</p></body></html>"
        dummyWebView?.loadHTMLString(htmlString, baseURL: nil)
        dummyWebView = nil;
    }
}

extension AppDelegate {
    func firebaseSetup(){
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "ios_latest_version")
        fetchConfig()
    }
    
    func fetchConfig() {
        var expirationDuration = 3600
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        
        var current:Double = 0
        var updated:Double = 0
        
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            current = Double(currentVersion)!
        }
        if let updatedVersion = remoteConfig["ios_latest_version"].stringValue{
            if updatedVersion != ""{
                updated = Double(updatedVersion)!
            }
        }
        
        if updated > current {
            let alertController = UIAlertController(title: "", message: "A new app version is available on App Store. Please update the Wishfin app to get the new features and benefits.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
                UIAlertAction in
                guard let url = URL(string: "https://apps.apple.com/us/app/wishfin/id1448228668") else {
                    return //be safe
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(okAction)
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
