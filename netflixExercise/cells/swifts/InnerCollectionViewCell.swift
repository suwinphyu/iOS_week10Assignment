//
//  InnerCollectionViewCell.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import SDWebImage

protocol DetailDelegate {
    func onClickCell(movieId: Int32)
}
class InnerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "InnerCollectionViewCell"

  var delegate : DetailDelegate?
    
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
      initGestureRecognizer()
    }
    func initGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickViewDetails))
        imgViewMoviePoster.isUserInteractionEnabled = true
        imgViewMoviePoster.addGestureRecognizer(tapGesture)
    }
    @objc func onClickViewDetails(){
        delegate?.onClickCell(movieId: data?.id ?? 0)
    }

}
