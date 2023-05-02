//
//  GoldVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 21/10/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

var App_Color = UIColor.clear
var App_Black_Color = UIColor.clear


class GoldVC: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var sellBtn: UIButton!
    /// uiview variable fr contents
       @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!

    /// which controller are child of this
      fileprivate lazy var viewControllers: [UIViewController] = {
          return self.preparedViewControllers()
      }()
      
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
          setupScrollView()
         viewSetup()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    

       
    }
    
    func viewSetup() {
        self.navigationItem.title = "PEPTalk"
        
        
        self.buyBtn.backgroundColor = App_Color
        self.sellBtn.backgroundColor = App_Black_Color
        // setSegmentColor(selectedIndex: 0)
    }
    
    // Example viewControllers
    
    /// returns child viewcontrollers instance
    ///
    /// - Returns: viewcontrollers variable
    fileprivate func preparedViewControllers() -> [UIViewController] {
        
        // NewFriendRequestVC = Request Frindes
        
          // PeopleYouMayVC =  Frindes Suggestions
        
        // FriendsListVC = My frindes list
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        
        let firstViewController = storyboard
            .instantiateViewController(withIdentifier: "BuyVC") as! BuyVC
        
        let secondViewController = storyboard
            .instantiateViewController(withIdentifier: "SellVC") as! SellVC
      
        
        return [
            firstViewController,
            secondViewController
        ]
    }
    
    
    // MARK: - Setup container view
    
    /// function to set up scrollview
    fileprivate func setupScrollView() {
        
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChild(viewController)
            scrollView.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        }
    }
    
    
    /// function to set selcted segment's data
    ///
    /// - Parameter selectedIndex: selectedIndex description
    func setSegmentColor (selectedIndex : Int) {
        
        if selectedIndex == 0 {
          
            self.buyBtn.backgroundColor = App_Color
                  self.sellBtn.backgroundColor = App_Black_Color

        }
        else
        {
           self.buyBtn.backgroundColor = App_Color
                 self.sellBtn.backgroundColor = App_Black_Color
        }
    }

    
    @IBAction func sessionsBtnAction(_ sender: Any) {
           self.buyBtn.backgroundColor = App_Color
           self.sellBtn.backgroundColor = App_Black_Color
        
        setSegmentColor(selectedIndex: 0)
        let contentOffsetX = scrollView.frame.width * CGFloat(0)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
                   
          }
       
       //  show the result of studios List in home screen
       @IBAction func studiosBtnAction(_ sender: Any) {
           self.buyBtn.backgroundColor = App_Color
           self.sellBtn.backgroundColor = App_Black_Color
                setSegmentColor(selectedIndex: 1)
                   let contentOffsetX = scrollView.frame.width * CGFloat(1)
                        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
                     
          }
}


/// MARK: - uiscrollview delegate methods
extension GoldVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        let selectedSegmentIndex = Int(currentPage)
        self.setSegmentColor(selectedIndex: selectedSegmentIndex)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
//    }
//
    
    
    
}
