//
//  OuterCollectionViewCell.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/14/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit

class OuterCollectionViewCell: UICollectionViewCell {
    let numberOfItemsPerRow : CGFloat = 3.0
    let spacing : CGFloat = 5
  
  var delegate : DetailDelegate?
    
    @IBOutlet weak var outerCollectionView: UICollectionView!
    var moviesByCategory : [MovieVO] = []
    
    var data : Objects? {
        didSet {
            if let data = data {
                switch data.sectionName {
                case "Now Playing" : moviesByCategory = data.sectionObjects
                    break
                case "Trending" : moviesByCategory = data.sectionObjects
                    break
                case "Upcoming" : moviesByCategory = data.sectionObjects
                    break
                case "Top Rate" : moviesByCategory = data.sectionObjects
                    break
               
                case .none:
                    break
               
                case .some(_):
                    break
                }
                
                }
            }
        }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
            let layout = outerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: outerCollectionView.frame.width/3, height:outerCollectionView.frame.height)
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            
            outerCollectionView.delegate = self
            outerCollectionView.dataSource = self
            outerCollectionView.registerForItem(strID: String(describing: InnerCollectionViewCell.self))
        
    
    }
    
   
    
   
}

extension OuterCollectionViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesByCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InnerCollectionViewCell.self), for: indexPath) as! InnerCollectionViewCell
        item.delegate = self.delegate
        item.data = moviesByCategory[indexPath.row]
        return item
    }
}

extension OuterCollectionViewCell : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }

}


