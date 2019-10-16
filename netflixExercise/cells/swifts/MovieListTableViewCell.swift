//
//  MovieListTableViewCell.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import CoreData

class MovieListTableViewCell: UITableViewCell {


    var fetchResultController: NSFetchedResultsController<MovieVO>!
    var movies = [MovieResponse]()
    // var movieVO = [MovieVO]()
    let TAG : String = "MovieListTableViewCell"
    
    
    @IBOutlet weak var lblMovieType: UILabel!
    
    @IBOutlet weak var outerCollectionView: UICollectionView!

//    var movieDictionary :[String : [MovieVO] ] = [ "Trending" : [],
//                                                         "Now Playing" : [],
//                                                         "Upcoming" : [],
//                                                         "Top Rate" : [] ]
//
//    var objectArray = [Objects]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchTopRatedMovies()
//        self.fetchTrendingMovies()
//        self.fetchUpComingMovies()
//        self.fetchNowPlayingMovies()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = outerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 3
        layout.itemSize = CGSize(width:outerCollectionView.frame.width / 3 , height: outerCollectionView.frame.height)
        
        setupCollectionView()
        //Add RefreshControl
    //    self.outerCollectionView.addSubview(refreshControl)
        //Remove all cached data in URL Response
      //  URLCache.shared.removeAllCachedResponses()
       // self.fetchTopRatedMovies()
        
//        for (key, value) in movieDictionary {
//            objectArray.append(Objects(sectionName: key, sectionObjects: value))
//            print("\(key) -> \(value)")
//        }
    //  outerCollectionView.reloadData()
        
    }

    func setupCollectionView(){
        outerCollectionView.dataSource = self
        outerCollectionView.delegate = self
        outerCollectionView.registerForItem(strID: String(describing: InnerCollectionViewCell.self))
        
        //register for supplymentary section
        outerCollectionView.register(UINib(nibName: String(describing: CustomSectionCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CustomSectionCollectionReusableView.self))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    

}


extension MovieListTableViewCell : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        outerCollectionView.reloadData()
    }
}


extension MovieListTableViewCell : UICollectionViewDelegate{
    //for section header- supplementary
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CustomSectionCollectionReusableView.self), for: indexPath) as! CustomSectionCollectionReusableView
        
       // sectionHeaderView.mData = objectArray[indexPath.section].sectionName
        return sectionHeaderView
    }
    
}

extension MovieListTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return objectArray[section].sectionObjects.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InnerCollectionViewCell.self), for: indexPath)
            as! InnerCollectionViewCell
      //  item.data = objectArray[indexPath.section].sectionObjects[indexPath.row]
        return item
    }
    
    //for section header- supplementary
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       // return objectArray.count
        return 2
    }
    
}

extension MovieListTableViewCell{
//    fileprivate func fetchTopRatedMovies() {
//        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
//
//            data.forEach({ (movieInfo) in
//               MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
//                let trending : [MovieResponse] = [movieInfo]
//                print(trending)
//              //  self?.movieDictionary["Top Rate"] = trending
//            })
//
//            DispatchQueue.main.async {
//                self?.refreshControl.endRefreshing()
//            }
//
//        }
//    }
//    fileprivate func fetchTrendingMovies() {
//        MovieModel.shared.getPopularMovies(pageId: 1) { [weak self] data in
//
//            data.forEach({ (movieInfo) in
//                MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
//                let trending : [MovieResponse] = [movieInfo]
//               // self?.movieDictionary["Trending"] = trending
//            })
//
//            DispatchQueue.main.async {
//                self?.refreshControl.endRefreshing()
//            }
//
//        }
//    }
//    fileprivate func fetchUpComingMovies() {
//        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
//
//            data.forEach({ (movieInfo) in
//                MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
//                let upComing : [MovieResponse] = [movieInfo]
//              //  self?.movieDictionary["Upcoming"] = upComing
//            })
//
//            DispatchQueue.main.async {
//                self?.refreshControl.endRefreshing()
//            }
//
//        }
//    }
//    fileprivate func fetchNowPlayingMovies() {
//        MovieModel.shared.getNowPlayingMovies(pageId: 1) { [weak self] data in
//
//            data.forEach({ (movieInfo) in
//                MovieResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
//                let topRate : [MovieResponse] = [movieInfo]
//              //  self?.movieDictionary["Top Rate"] = topRate
//            })
//
//            DispatchQueue.main.async {
//                self?.refreshControl.endRefreshing()
//            }
//
//        }
//
//    }
    fileprivate func bindData(movies: [MovieVO]){
        //self.movieVO = movies
        self.outerCollectionView.reloadData()
    }
    
    
    fileprivate func fetchTopRatedMovies() {
        
        var topRate : [MovieVO] = []
        
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
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
                        //let topRate : [MovieResponse] = [movieInfo]
//
                         print(movieInfo)
                         //topRate = [movieInfo]
                            topRate = [MovieResponse.convertToMovieVO(data: movieInfo, context: CoreDataStack.shared.viewContext)]
                            
                        })
                            //self?.movieDictionary["Top Rate"] = topRate
                        
                            DispatchQueue.main.async {
                            self?.refreshControl.endRefreshing()
                        
                        }
                    }
                }else{
                   //  self.movieDictionary["Top Rate"] = result
                    bindData(movies: result)
                }
               // print(movieDictionary)
             
            }
            
        }catch {
          //  Dialog.showAlert(viewController: UIViewController, title: "Error", message: "Failed to fetch data from database")
            
        }
        
    }
    
}
