//
//  Extensions.swift
//  TableViewExercise
//
//  Created by Su Win Phyu on 8/25/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerForCell(strID : String){
        register(UINib(nibName: strID, bundle: nil), forCellReuseIdentifier: strID)
    }
    
}

extension UICollectionView {
    func registerForItem(strID : String){
        
        register(UINib(nibName: strID, bundle: nil), forCellWithReuseIdentifier: strID )
    }
}

