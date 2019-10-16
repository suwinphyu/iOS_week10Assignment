//
//  MovieListViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/14/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import CoreData
import Reachability


class MovieListViewController: UIViewController {
    static let identifier = "MovieListViewController"
    var delegate : DetailDelegate?
    
    var fetchResultController: NSFetchedResultsController<MovieVO>!
    var movieDictionary :[String : [MovieVO] ] = [ "Trending" : [],                                                                                          "Now Playing" : [],
                                                   "Upcoming" : [],
                                                   "Top Rate" : [] ]
    
    var objectArray = [Objects]()
    
    @IBOutlet weak var collectionViewMovieList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Movie List",UIImage(named: "logo.png")!)
        setupCollectionView()
       
        self.fetchTrendingMovies()
        self.fetchNowPlayingMovies()
        self.fetchUpComingMovies()
        self.fetchTopRatedMovies()
        for (key, value) in movieDictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
            // print("\(key) -> \(value)")
            // print(objectArray[1].sectionObjects as Any)
        }
        movieDictionary.removeAll()
        
        
        let layout = collectionViewMovieList.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: (self.view.frame.width), height: 190)
        
    }
    func setupCollectionView(){
        collectionViewMovieList.delegate = self
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.registerForItem(strID: String(describing: OuterCollectionViewCell.self))
        
        
        //register for supplymentary section
        collectionViewMovieList.register(UINib(nibName: String(describing: CustomSectionCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CustomSectionCollectionReusableView.self))
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchTrendingMovies()
        self.fetchNowPlayingMovies()
        self.fetchUpComingMovies()
        self.fetchTopRatedMovies()
    }
    
    
}

extension MovieListViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OuterCollectionViewCell.self), for: indexPath) as! OuterCollectionViewCell
        item.delegate = self
       // item.data = objectArray[indexPath.section].sectionObjects[indexPath.row]
       // item.data = objectArray
        item.data = objectArray[indexPath.section]
        return item
    }
    
    //for section header- supplementary
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return objectArray.count
       // return 4
    }
    
    
}

extension MovieListViewController : UICollectionViewDelegate{
    //for section header- supplementary
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CustomSectionCollectionReusableView.self), for: indexPath) as! CustomSectionCollectionReusableView
        
        sectionHeaderView.mData = objectArray[indexPath.section].sectionName
        return sectionHeaderView
    }
    
    
    
    
}

extension MovieListViewController : DetailDelegate{
    func onClickCell(movieId: Int32) {
//                if NetworkUtil.checkReachable() == false {
//                    Dialog.showAlert(viewController: self, title: "Network Error", message: SharedConstants.ErrorMessage.NetworkError)
//                    return
//                }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController
        detailViewController.movieId = movieId
            self.present(detailViewController, animated: true, completion: nil)
    
    }
    
}



extension MovieListViewController {
    func setTitle(_ title: String,_ logo: UIImage) {
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: 50 , height: 50))
        let imgView = UIImageView(frame: CGRect(x: -180, y: 0, width: 100, height: 40))
        imgView.contentMode = .scaleAspectFit
        let image = logo
        imgView.image = image
        navigationView.addSubview(imgView)
        
        let label : UILabel = UILabel(frame: CGRect(x: -30, y: 3, width: 150, height: 25))
        label.text = title
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        navigationView.addSubview(label)
        
        navigationItem.titleView = navigationView
        
    }
}


extension MovieListViewController{
    
    fileprivate func bindData(movies: [MovieVO]){
        //self.movieVO = movies
        self.collectionViewMovieList.reloadData()
    }
    
    fileprivate func fetchTrendingMovies() {
        
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "")
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let result = fetchResultController.fetchedObjects {
                if result.isEmpty {
                    MovieModel.shared.fetchPopularMovies(pageId: 1) { [weak self] data in
                        data.forEach({ (movieInfo) in
                            MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
                            self?.movieDictionary["Trending"] = [MovieResponse.convertToMovieVO(data: movieInfo, context: CoreDataStack.shared.viewContext)]
                        })
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                    }
                    collectionViewMovieList.reloadData()
                }else {
                     movieDictionary["Trending"] = result
                }
                
            }
        }catch {
            print("TAG : \(error.localizedDescription)")
        }
        //TODO : Fetch & Display Movie Info
        if let result = try? CoreDataStack.shared.viewContext.fetch(fetchRequest){
            if result.isEmpty{
                fetchTopRatedMovies()
            }else {
                bindData(movies: result)
            }
        }
    }
    
  
    fileprivate func fetchNowPlayingMovies() {
        
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "release_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "")
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let result = fetchResultController.fetchedObjects {
                if result.isEmpty {
                    MovieModel.shared.fetchNowPlayingMovies(pageId: 1) { [weak self] data in
                        data.forEach({ (movieInfo) in
                            MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
                            self?.movieDictionary["Now Playing"] = [MovieResponse.convertToMovieVO(data: movieInfo, context: CoreDataStack.shared.viewContext)]
                        })
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                    }
                    collectionViewMovieList.reloadData()
                }
                else{
                     movieDictionary["Now Playing"] = result
                }
               
            }
        }catch {
            print("TAG : \(error.localizedDescription)")
        }
        //TODO : Fetch & Display Movie Info
        if let result = try? CoreDataStack.shared.viewContext.fetch(fetchRequest){
            if result.isEmpty{
                fetchTopRatedMovies()
            }else {
                bindData(movies: result)
            }
        }
    }
    
    
    
    fileprivate func fetchUpComingMovies() {
        
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "release_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "")
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let result = fetchResultController.fetchedObjects {
                if result.isEmpty {
                    MovieModel.shared.fetchUpComingMovies(pageId: 1) { [weak self] data in
                        data.forEach({ (movieInfo) in
                            MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
                            self?.movieDictionary["UpComing"] = [MovieResponse.convertToMovieVO(data: movieInfo, context: CoreDataStack.shared.viewContext)]
                        })
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                    }
                    collectionViewMovieList.reloadData()
                }
                else{
                    movieDictionary["UpComing"] = result
                }
                
            }
        }catch {
            print("TAG : \(error.localizedDescription)")
        }
        //TODO : Fetch & Display Movie Info
        if let result = try? CoreDataStack.shared.viewContext.fetch(fetchRequest){
            if result.isEmpty{
                fetchTopRatedMovies()
            }else {
                bindData(movies: result)
            }
        }
    }
    
    fileprivate func fetchTopRatedMovies() {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "vote_count", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "")
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let result = fetchResultController.fetchedObjects {
                if result.isEmpty {
                    MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
                        data.forEach({ (movieInfo) in
                            MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
                            self?.movieDictionary["Top Rate"] = [MovieResponse.convertToMovieVO(data: movieInfo, context: CoreDataStack.shared.viewContext)]
                        })
                        DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        }
                    }
                    collectionViewMovieList.reloadData()
                }else{
                      movieDictionary["Top Rate"] = result
                }
           
            }
            
        }catch {
            print("TAG : \(error.localizedDescription)")
        }
        
        //TODO : Fetch & Display Movie Info
        if let result = try? CoreDataStack.shared.viewContext.fetch(fetchRequest){
            if result.isEmpty{
                fetchTopRatedMovies()
            }else {
                bindData(movies: result)
            }
        }
    }

}

extension MovieListViewController : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionViewMovieList.reloadData()
    }
}



