//
//  CardsNewCell.swift
//  Wishfin
//
//  Created by Vijay Yadav on 27/10/20.
//  Copyright © 2020 Wishfin. All rights reserved.
//

import UIKit

class CardsNewCell: UITableViewCell {

    @IBOutlet weak var collctionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionSetup()
    {
        self.collctionView.register(UINib(nibName: "CardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionCell")
              let flowlayout = UICollectionViewFlowLayout()
              
              flowlayout.scrollDirection = .horizontal
              self.collctionView.collectionViewLayout = flowlayout
        self.collctionView.reloadData()
    }
    
    func cardListDataSet(data:String)
    {
        collectionSetup()
    }
    
}


/// MARK: - extension for UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout methods
extension CardsNewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth , height: 150)
    }
}
