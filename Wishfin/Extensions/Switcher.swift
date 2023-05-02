//
//  Switcher.swift
//  TabBarAfterLogin
//
//  Created by AMD on 05/04/19.
//  Copyright © 2019 AMD. All rights reserAMD.
//

import Foundation
import UIKit

class Switcher {
    
    //MARK:- Variable
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK:- Class Method
    
    /// update the root View Controller as per login status
    static func updateRootVC(SelIndex:Int){
        if Defaults.getSession() {
            setTabBar(SelIdx: SelIndex)
        }
        else {
            
            Defaults.setCardUnlock(false)
            
            let rootVC = Identifier.mainStoryBoard.instantiateViewController(withIdentifier: ViewController.className()) as! ViewController
            let navigationVC = UINavigationController(rootViewController: rootVC)
            appDelegate.window?.rootViewController = navigationVC
        }
    }
    
    /// Initialise the UI for tab baar
    static func setTabBar(SelIdx:Int) {
        let dashboardVC = Identifier.mainStoryBoard.instantiateViewController(withIdentifier: "dashboardVC") as! UINavigationController
        let tabbar = dashboardVC.viewControllers.first as! UITabBarController
        
        let homeVCNavigationController = setNavigationForTabBar(selectedImagestring: "homeSelected", unslectedimageString: "home", tabBarTitle: "Home", viewController: DashboardVC())
        
        let retailerVCNavigationController = setNavigationForTabBar(selectedImagestring: "loanSelected", unslectedimageString: "loan", tabBarTitle: "Loans", viewController: LoanReportVC())
        
//         let goldVCNavigationController = setNavigationForTabBar(selectedImagestring: "loanSelected", unslectedimageString: "loan", tabBarTitle: "Loans", viewController: GoldVC())
//
        
        
        let contentVCNavigationController = setNavigationForTabBar(selectedImagestring: "cardSelected", unslectedimageString: "cards", tabBarTitle: "Cards", viewController: CreditCardReportVC())
//
//        let settingVCNavigationController = setNavigationForTabBar(selectedImagestring: "profile", unslectedimageString: "profileUnselected", tabBarTitle: "Profile", viewController: SavingCardVC())
        
        var vc:UIViewController = MyOffersV_C()
        
        if Defaults.getCardUnlock() {
            vc = SavingCardVC()
        }
        
        
        let settingVCNavigationController = setNavigationForTabBar(selectedImagestring: "offerSelected", unslectedimageString: "offer", tabBarTitle: "Offers", viewController: vc)// MyOffersV_C()) //SavingCardVC())
        
        
        tabbar.viewControllers = [homeVCNavigationController, retailerVCNavigationController,contentVCNavigationController, settingVCNavigationController]
        appDelegate.window?.rootViewController = dashboardVC
        
        
        tabbar.selectedIndex = SelIdx
       
    }
    
    static func setNavigationForTabBar(selectedImagestring: String, unslectedimageString: String,tabBarTitle:String, viewController: UIViewController) -> UINavigationController {
        let navigationControllerObj = UINavigationController(rootViewController: viewController)
        navigationControllerObj.tabBarItem.title = tabBarTitle
        navigationControllerObj.tabBarItem.image = UIImage(named: unslectedimageString)?.withRenderingMode(.alwaysOriginal)
        navigationControllerObj.tabBarItem.selectedImage = UIImage(named: selectedImagestring)?.withRenderingMode(.alwaysOriginal)
        return navigationControllerObj
    }
}
