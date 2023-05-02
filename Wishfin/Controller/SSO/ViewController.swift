//
//  ViewController.swift
//  Wishfin
//
//  Created by Wishfin on 09/09/19.
//  Copyright © 2019 Wishfin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollview: UIScrollView!
    
    //MARK: Variables
    var slides:[SlideView] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView(slides: slides)
    }
    
    /// Setting View
    func setupView(){
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
   
    func createSlides() -> [SlideView] {
        let slide1:SlideView = Bundle.main.loadNibNamed(SlideView.className(), owner: self, options: nil)?.first as! SlideView
        slide1.coverImage.image = UIImage(named: "first")
        slide1.titleLabel.text = "Detailed credit report"
        slide1.detailLabel.text = "CIBIL Score by TransUnion, Credit Card Dashboard, On-time Bill Payment Monitor, Loan Inquiry History"
        
        let slide2:SlideView = Bundle.main.loadNibNamed(SlideView.className(), owner: self, options: nil)?.first as! SlideView
        slide2.coverImage.image = UIImage(named: "second")
        slide2.titleLabel.text = "Credit improvement tips"
        slide2.detailLabel.text = "Take corrective action using our specific AI-generated Tips based on your Credit Behaviour"
        
        let slide3:SlideView = Bundle.main.loadNibNamed(SlideView.className(), owner: self, options: nil)?.first as! SlideView
        slide3.coverImage.image = UIImage(named: "third")
        slide3.titleLabel.text = "100% Safe & secure"
        slide3.detailLabel.text = "The information you enter will only be used to authenticate only"
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [SlideView]) {
        scrollview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/1.5)
        scrollview.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height/1.5)
        scrollview.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height/1.5)
            scrollview.addSubview(slides[i])
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        Defaults.setLaunched(true)
        let reg1VC = Registration1VC.init(nibName: Registration1VC.className(), bundle: nil)
        self.navigationController?.pushViewController(reg1VC, animated: true)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        Defaults.setLaunched(true)
        let reg1VC = LoginVC.init(nibName: LoginVC.className(), bundle: nil)
        self.navigationController?.pushViewController(reg1VC, animated: true)
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
}
