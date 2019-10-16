//
//  MovieDetailsViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/12/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class MovieDetailsViewController: UIViewController {
    static let identifier = "MovieDetailsViewController"
    
    var detailFetchResultController: NSFetchedResultsController<MovieVO>!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    //var delegate : NavigateToDetailDelegate?
    var similarMoviesList : [MovieVO]?
    
    var movieId : Int32 = 0
    
    let sessionId = UserDefaults.standard.object(forKey: "session") as? String
    let accountId = UserDefaults.standard.object(forKey: "account_id") as? Int
  
    @IBOutlet weak var imgViewMovie: UIImageView!
    
    @IBOutlet weak var lblMovieName: UILabel!
    
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    @IBOutlet weak var lblIsAdult: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblMovieOverview: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       fetchMovieDetails(movieId: movieId)
        fetchSimilarMovies(movieId: movieId)
      setupCollectionView()
        
    }
    
    func setupCollectionView(){
       similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.registerForItem(strID: String(describing: SimilarMoviesCollectionViewCell.self))
        
        let layout = similarMoviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: similarMoviesCollectionView.frame.width/3, height:140)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
    }
    
    func fetchMovieDetails(movieId: Int32){
//        if NetworkUtils.checkReachable() == false {
//            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
//            if let data = MovieVO.getMovieById(movieId: movieId) {
//                self.bindData(data: data)
//            }
//            return
//        }
        
        MovieModel.shared.fetchMovieDetails(movieId: Int(movieId)) { movieDetails in
            
            let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", self.movieId)
            fetchRequest.predicate = predicate
            if let movies = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !movies.isEmpty {
                MovieResponse.updateMovieEntity(existingData: movies[0], newData: movieDetails, context: CoreDataStack.shared.viewContext)
                DispatchQueue.main.async { [weak self] in
                    self?.bindData(data: movies[0])
                }
            } else {
                let movieVO = MovieResponse.convertToMovieVO(data: movieDetails, context: CoreDataStack.shared.viewContext)
                
                DispatchQueue.main.async { [weak self] in
                    self?.bindData(data: movieVO)
                }
            }
            
        }
    }
 
    fileprivate func fetchSimilarMovies (movieId: Int32){
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", self.movieId)
        fetchRequest.predicate = predicate
        if let result = try? CoreDataStack.shared.viewContext.fetch(fetchRequest)
        {
                if result.isEmpty {
                    MovieModel.shared.fetchSimilarMovie(movieId: Int(movieId)) { [weak self] data in
                        data.forEach({ (movieInfo) in
                            MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
                            
                        })
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                    }
                    
                }else{
                    similarMoviesList = result
                    similarMoviesCollectionView.reloadData()
                }
            
        }
    }
    
    fileprivate func bindData(data : MovieVO) {
        
       imgViewMovie.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
        lblMovieName.text = data.title ?? "Jocker"
        lblReleaseDate.text = data.release_date ?? "2019"
        if data.adult {
            lblIsAdult.text = "18+"
        }else{
            lblIsAdult.text = "18-"
        }
        lblMovieOverview.text = data.overview
        lblDuration.text = convertToMin(minute: Int(data.runtime))
   

    }
    
    fileprivate func fetchVideoKey(movieId: Int){
        MovieModel.shared.fetchVideoKey(movieId: movieId, completion: { [weak self] videos in
            DispatchQueue.main.async { [weak self] in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: PlayVideoViewController.self)) as! PlayVideoViewController
                vc.videoKey = videos.first?.key ?? ""
                self?.present(vc, animated: true)
            }
        })
    }
    
    fileprivate func AddRating(movieId: Int , sessionId : String){
        MovieModel.shared.postRateMovies(movieId: movieId, sessionId: sessionId , completion: { [weak self] status_message in
             DispatchQueue.main.async { [weak self] in

                if status_message == "Success" {
                    Dialog.showAlert(viewController: self!, title: "Rating Movies", message: "Add rating for movies is success")
                    
                }else {
                     Dialog.showAlert(viewController: self!, title: "Rating Movies", message: "The item/record was updated successfully.")
                }
                
                
            }
        })
    }
    
    
    fileprivate func AddToWatchList(movieId: Int ,accountId: Int, sessionId : String){
        MovieModel.shared.postWatchList(movieId: movieId, accountId: accountId, sessionId: sessionId, completion: { [weak self] status_message in
            DispatchQueue.main.async { [weak self] in
                
                if status_message == "Success" {
                    Dialog.showAlert(viewController: self!, title: "Add To Watch List", message: "Success for Adding to watch list")
                    
                }else {
                    Dialog.showAlert(viewController: self!, title: "Add To Watch List", message: "The item/record was updated successfully.")
                }
               
                
            }
        })
    }
    
    
    fileprivate func convertToMin(minute: Int) -> String{
        let hour: Int = minute/60
        let min: Int = minute % 60
        
        return "\(hour)hr \(min)min"
    }
    

    @IBAction func btnCloseMovieDetails(_ sender: Any) {
         UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func btnPlayMovie(_ sender: Any) {
        self.fetchVideoKey(movieId: Int(movieId))
    }
    
    
    @IBAction func btnAddWatchList(_ sender: Any) {
        if let sessionId = sessionId{
            if let accountId = accountId {
        
                self.AddToWatchList(movieId: Int(movieId), accountId: accountId, sessionId: sessionId)
                
            }else {
                Dialog.showAlert(viewController: self, title: "Fail to add ", message: "Please login again to add watch list")
            }
           
        } else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
                self.present(vc, animated: true)
        }
        
       
    }
    
    
    @IBAction func btnAddTopRate(_ sender: Any) {
        
        if let sessionId = sessionId{
              self.AddRating(movieId: Int(movieId), sessionId: sessionId)
    
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
            self.present(vc, animated: true)
        }
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
       
    }
}

extension MovieDetailsViewController : UICollectionViewDelegate{}

extension MovieDetailsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMoviesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SimilarMoviesCollectionViewCell.self), for: indexPath) as! SimilarMoviesCollectionViewCell
        item.data = similarMoviesList?[indexPath.row]
        return item
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        // return 4
    }
}

extension MovieDetailsViewController : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        similarMoviesCollectionView.reloadData()
    }
}
