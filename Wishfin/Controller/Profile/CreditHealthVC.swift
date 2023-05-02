//
//  CreditHealthVC.swift
//  TestingDemo
//
//  Created by Vedvyas Rauniyar on 21/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

/*
 Credit Health / Cibil Score
 
 
 */

import UIKit

class CreditHealthVC: UIViewController {

    @IBOutlet weak var credHealthTableView: UITableView!
    var titleArray = [String]()
    var detailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        titleArray = ["Is this Credit Score genuine?  Will it be accepted by banks?","Is my Cibil Check FREE?","What is the 12 month Free Cibil Membership?","Is it safe to give my personal and financial information? Do my banking details stay private and secure?","I did not receive my CIBIL Score. What is the issue?","Will checking my Credit Score reduce my CIBIL Score?"]
        
        detailArray = ["The Credit Score on Wishfin FinHealth App is provided by TransUnion CIBIL, the gold standard of Credit Scores and the only Credit Score truly accepted by Banks. This is because Wishfin is an Official Partner of TransUnion CIBIL. The Score is directly fetched from the CIBIL servers.","Normally checking Cibil Score can cost upwards of Rs. 500.However, Checking Cibil Score on the Wishfin FinHealth App is 100% Free for Wishfin users. You can check your score multiple times for Free. All you have to do is authenticate and login to the app.","Wishfin users get a Free 12 month CIBIL Check Subscription by registering on the App or on wishfin.com. You can check you Score any number of times on the app or on the website to track your Credit Health over time. You will also receive monthly reminders to check your Score to check your progress. Wishfin recommends that you check your score at least once a month to make the most of this subscription and to stay credit healthy! Note that checking Cibil on Wishfin App DOES NOT reduce your score.","The information you provide on the app is exclusively for the purpose of fetching your Cibil Score. Only information that is absolutely required for authentication of your records and generating a score is asked. The information is sent directly to Cibil servers which triggers the score. Your report is analysed to provide you with actionable insights on your credit health.Wishfin takes your privacy and security very seriously. Your information is 100% secured and password protected. Hence you will only be able to access your report after your account is verified and authenticated. The information is not used for any purpose other that what you consent to.","Wishfin does not generate the score on its own. Your score and report is generated directly by TransUnion Cibil and is displayed to you on the app. Wishfin is not directly privy to the exact reasons why TransUnion did not generate a score for you. However, possible reasons could be: 0/-1 Score generated - You have no Credit History as of now (or as per Cibil Records)  due to not having used a Credit Product. This is not necessarily a bad thing. Build your Credit History by using Credit products over time. Watch out for Wishfin tips to help you with the same! No Score generated - Cibil may not have been able to authenticate your records and identity due to a mismatch between the information you entered and the information according to your banking records, which Cibil may have access to. Please retry using the correct information or check / update your banking records. Make sure they match.For more information, please contact the TransUnion Cibil helpline at +91 - 22 - 6140 4300","No. Checking your score on the app DOES NOT REDUCE YOUR Score, despite what you may have heard. When YOU check your Cibil Score using Wishfin, it constitutes a ‘Soft Request’, which has no negative impact on your score. However, if you apply for a financial product, the Bank may run a Cibil check, which constitutes a ‘Hard Request’ - this may negatively impact your Score.Hence it is advisable to check your Cibil using a service like Wishfin BEFORE applying, rather than making repeated applications for financial products via banks."]

        setUpTableView()
    }

    /// Set Table View
    func setUpTableView() {
        // Register Cells
        self.credHealthTableView.register(UINib.init(nibName: "HelpCell", bundle: nil), forCellReuseIdentifier: "HelpCell")
        self.credHealthTableView.tableFooterView = UIView()
        self.credHealthTableView.rowHeight = 64.0
        self.credHealthTableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: UITableView Datasource
extension CreditHealthVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell
        cell.setupCellUI(title: titleArray[indexPath.row])
        return cell
    }
}

// MARK: UITableView Delegate
extension CreditHealthVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = HelpDetailVC.init(nibName: "HelpDetailVC", bundle: nil)
        obj.titleString = titleArray[indexPath.row]
        obj.detailString = detailArray[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
   
}
