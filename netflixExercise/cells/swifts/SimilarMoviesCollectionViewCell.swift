//
//  SimilarMoviesCollectionViewCell.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/15/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgViewMoviePoster: UIImageView!
    
    var data : MovieVO? {
        didSet {
            if let data = data {
                imgViewMoviePoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
