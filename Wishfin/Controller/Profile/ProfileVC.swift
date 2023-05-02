//
//  ProfileVC.swift
//  BlurView
//
//  Created by Vedvyas Rauniyar on 13/11/19.
//  Copyright © 2019 Vedvyas Rauniyar. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var phoneEmailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var midView: UIView!
    
    //MARK: Variables
    let titleArray = ["Share this App","Terms & Conditions","Privacy Policy","Help & Support"]
    let imageArray = ["share","term","pp","help"]
    
    //MARK: Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        if let data = UserDefaults.standard.data(forKey: DefaultsKey.loginDetails),
            let model = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginModel {
            nameLabel.text = model.first_name
            phoneEmailLabel.text = "+91-\(model.mobile_number) | \(model.email_id)"
        }
        midView.setShadowOnAllSidesOfView(shadowSizeValue: 10)
        setUpTableView()
    }
    
    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.profileTableView.register(UINib.init(nibName: ProfileCell.className(), bundle: nil), forCellReuseIdentifier: ProfileCell.className())
        self.profileTableView.tableFooterView = UIView()

    }

    @IBAction func logoutClicked(_ sender: Any) {
        showLogoutAlert()
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "YES",style: .default,handler: {(_: UIAlertAction!) in
            //Sign out action
            Defaults.resetData()
            Defaults.setSession(false)
            Switcher.updateRootVC(SelIndex: 0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func BackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
// MARK: UITableView Datasource
extension ProfileVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className(), for: indexPath) as! ProfileCell
        cell.setupCellUI(title: titleArray[indexPath.row], imageName: imageArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView Delegate
extension ProfileVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            shareLink()
        case 1:
            NavigateToTerms()
        case 2:
            NavigateToPrivacy()
        case 3:
            NavigateToHelp()
        default:
            print("")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension ProfileVC {
    func NavigateToTerms(){
        let obj = TermsnCondVC.init(nibName: TermsnCondVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func NavigateToPrivacy(){
        let obj = PrivacyVC.init(nibName: PrivacyVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func NavigateToHelp(){
        let obj = HelpSupportVC.init(nibName: HelpSupportVC.className(), bundle: nil)
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func shareLink(){
        let firstActivityItem = "Just checked my CIBIL Score on the Wishfin App for Free. It’s a must-have tool to maintain Financial Discipline. The best part is you can check your score monthly for free, track progress over time & get tips to improve your credit health. It’s privacy-protected & checking does not bring down your score.\n\nThought you would find it useful. Download the Wishfin App & check your CIBIL Free at https://apps.apple.com/us/app/wishfin/id1448228668"
        let secondActivityItem : NSURL = NSURL(string:"https://apps.apple.com/us/app/wishfin/id1448228668")!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = midView
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
//Class ends here
