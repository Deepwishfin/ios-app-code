//
//  OfferDealsVC.swift
//  Wishfin
//
//  Created by Vijay Yadav on 09/11/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class OfferDealsVC: UIViewController ,UIScrollViewDelegate{
    
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var expiredBtn: UIButton!
    
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var expiredLbl: UILabel!
    
    @IBOutlet weak var dealsBtn: UIButton!
    var cibilId = ""
    var activeCount = "0"
    var expiredCount = "0"
     
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDealsData(notif:)), name: Notification.Name("dataSetOnDeals"), object: nil)
        setupScrollView()
        viewSetup()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    //MARK:- notification Action
    @objc func showDealsData(notif :  NSNotification){
        
        print(notif.userInfo!)
        let dict = notif.userInfo! as NSDictionary
        
        if dict["activeDeal"]  != nil
        {
//            self.dealsBtn.setTitle("\(dict["activeDeal"] as? String ?? "0") Deals", for: .normal)
            activeCount = dict["activeDeal"] as? String ?? "0"
        }
        
        if dict["expiredDeal"]  != nil
        {
//            self.dealsBtn.setTitle("\(dict["expiredDeal"] as? String ?? "0") Deals", for: .normal)
            expiredCount = dict["expiredDeal"] as? String ?? "0"
        }
         
            self.dealsBtn.setTitle("\(activeCount) Deals", for: .normal)
         
    }
    
    func viewSetup() {
        //    self.navigationItem.title = "PEPTalk"
        
        hideNavigationBar()
        self.activeBtn.backgroundColor = App_Color
        self.expiredBtn.backgroundColor = App_Black_Color
        self.activeBtn.setTitle("Active".uppercased(), for: .normal)
        self.expiredBtn.setTitle("Expired", for: .normal)
        self.activeLbl.backgroundColor = UIColor.init(red: 30.0/255, green: 185.0/255, blue: 167.0/255, alpha: 1.0)
        self.expiredLbl.backgroundColor = UIColor.clear
        // setSegmentColor(selectedIndex: 0)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Example viewControllers
    
    /// returns child viewcontrollers instance
    ///
    /// - Returns: viewcontrollers variable
    fileprivate func preparedViewControllers() -> [UIViewController] {
        
        // NewFriendRequestVC = Request Frindes
        
        // PeopleYouMayVC =  Frindes Suggestions
        
        // FriendsListVC = My frindes list
        
        let storyboard = UIStoryboard.init(name: "OfferDeals", bundle: nil)
        
        let firstViewController = storyboard
            .instantiateViewController(withIdentifier: "ActiveDealsVC") as! ActiveDealsVC
        firstViewController.cibilId = cibilId
        
        let secondViewController = storyboard
            .instantiateViewController(withIdentifier: "ExpiredDealsVC") as! ExpiredDealsVC
        firstViewController.cibilId = cibilId
        
        
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
            
            self.activeBtn.backgroundColor = App_Color
            self.expiredBtn.backgroundColor = App_Black_Color
            
        }
        else
        {
            self.activeBtn.backgroundColor = App_Color
            self.expiredBtn.backgroundColor = App_Black_Color
        }
    }
    
    
    @IBAction func activeBtnAction(_ sender: Any) {
        self.activeBtn.backgroundColor = App_Color
        self.expiredBtn.backgroundColor = App_Black_Color
        self.activeBtn.setTitle("Active".uppercased(), for: .normal)
        self.expiredBtn.setTitle("Expired", for: .normal)
        dealsBtn.setTitle("\(activeCount) Deals", for: .normal)
        
        self.activeLbl.backgroundColor = UIColor.init(red: 30.0/255, green: 185.0/255, blue: 167.0/255, alpha: 1.0)
        self.expiredLbl.backgroundColor = UIColor.clear
        
        setSegmentColor(selectedIndex: 0)
        let contentOffsetX = scrollView.frame.width * CGFloat(0)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
        
    }
    
    //  show the result of studios List in home screen
    @IBAction func expireBtnAction(_ sender: Any) {
        self.activeBtn.backgroundColor = App_Color
        self.expiredBtn.backgroundColor = App_Black_Color
        self.activeBtn.setTitle("Active", for: .normal)
        self.expiredBtn.setTitle("Expired".uppercased(), for: .normal)
        dealsBtn.setTitle("\(expiredCount) Deals", for: .normal)
        
        self.activeLbl.backgroundColor = UIColor.clear
        self.expiredLbl.backgroundColor = UIColor.init(red: 30.0/255, green: 185.0/255, blue: 167.0/255, alpha: 1.0)
        setSegmentColor(selectedIndex: 1)
        let contentOffsetX = scrollView.frame.width * CGFloat(1)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
        
    }
}


/// MARK: - uiscrollview delegate methods
extension OfferDealsVC {
    
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

