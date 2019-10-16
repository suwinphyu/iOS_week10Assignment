//
//  PlayVideoViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/15/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class PlayVideoViewController: UIViewController {

    var videoKey: String?
    static let identifier = "PlayVideoViewController"
    
    @IBOutlet weak var moviePlayerView: WKYTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let key = videoKey else{ return }
        moviePlayerView.load(withVideoId: key)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    

    @IBAction func btnBack(_ sender: Any) {
        
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    

}



