//
//  SearchViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/17/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
  
    @IBOutlet weak var collectionViewMovieList: UICollectionView!
    @IBOutlet weak var lblMovieNotFound: UILabel!
  
    
    private var searchedResult = [MovieResponse]()
    
    let activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.color = UIColor.red
        ui.startAnimating()
        return ui
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Search Movies"
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    fileprivate func initView() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Eg: One upon a time in Hollywood"
        
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        
        
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.stopAnimating()
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = searchedResult[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        let movieVO = MovieResponse.convertToMovieVO(data: movie, context: CoreDataStack.shared.viewContext)
        
        cell.data = movieVO
        
        return cell
    }
    
    func bindData(_ results : [MovieResponse]) {
        DispatchQueue.main.async { [weak self] in
            if results.isEmpty {
                self?.lblMovieNotFound.text = "No movie found :("
                return
            }
            self?.searchedResult = results
            self?.lblMovieNotFound.text = ""
            self?.collectionViewMovieList.reloadData()
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        let searchedMovie = searchBar.text ?? ""
        
        //TODO :
        //Implement Search Movie API
        
        MovieModel.shared.SearchMoviesByName(moviename: searchedMovie, completion: { (movie) in
            self.bindData(movie)
        })
        
    }
    
}


extension SearchViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionViewMovieList.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movie = searchedResult[selectedIndexPath.row]
                movieDetailsViewController.movieId = Int32(Int(movie.id ?? 0))
                
                self.navigationItem.title = movie.original_title
            }
            
        }
    }
}


extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
