//
//  ProfileViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class ProfileViewController: UIViewController {

    static let identifier = "ProfileViewController"
    var fetchResultController : NSFetchedResultsController<UserVO>!
    var userVO : UserVO?
    
   
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    var id : Int?
    var hashkey : String?
    let sessionId = UserDefaults.standard.object(forKey: "session") as? String
     let username = UserDefaults.standard.object(forKey: "username") as? String
//    var sessionId : String?{
//        didSet {
//            if let data = sessionId {
//               fetchProfileInfo(sessionId: data)
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileInfo(sessionId: sessionId ?? "")
        lblUserName.text = username
       // print(sessionId)
        
    }
    
    fileprivate func fetchProfileInfo(sessionId: String){
        UserModel.shared.getAccount(sessionId: sessionId, completion: { [weak self] userAccountResponse in
            DispatchQueue.main.async { [weak self] in
                self?.lblUserName.text = userAccountResponse.username
               //  self?.imgViewProfile.sd_setImage(with: URL(string: API.BASE_IMG_URL + userAccountResponse.avatar.gravatar.hash), completed: nil)
                
               
            }
        })
    }
    


}
