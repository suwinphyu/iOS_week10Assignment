//
//  MovieModel.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation
class MovieModel{
    static let shared = MovieModel()
    private init(){}
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func fetchMovieGenres(completion : @escaping ([MovieGenreResponse]) -> Void ) {
        
        let route = URL(string: Routes.ROUTE_MOVIE_GENRES)!
        let task = URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieGenreListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.genres)
            }
        }
        task.resume()
    }
    
    func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_TOP_RATED_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                // print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieResponse]())
            }
            }.resume()
        
    }
    
    func fetchPopularMovies(pageId : Int = 1, completion : @escaping (([MovieResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_POPULAR_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieResponse]())
            }
            }.resume()
        
    }
    
    func fetchUpComingMovies(pageId : Int = 1, completion : @escaping (([MovieResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_UPCOMING_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieResponse]())
            }
            }.resume()
        
    }
    
    func fetchNowPlayingMovies(pageId : Int = 1, completion : @escaping (([MovieResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_NOW_PLAYING_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieResponse]())
            }
            }.resume()
        
    }
    
    func fetchVideoKey(movieId : Int = 1, completion : @escaping (([GetVideoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_GET_MOVIE_KEY)/\(movieId)/videos?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : VideoListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
               
                completion(data.results)
                
            } else {
                completion([GetVideoResponse]())
            }
            }.resume()
    }
    
    func fetchSimilarMovie(movieId : Int, completion: @escaping ([MovieResponse]) -> Void) {
        let route =  URL(string: "\(Routes.ROUTE_GET_SIMILAR_MOVIES)/\(movieId)/similar?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
            else {
                completion([MovieResponse]())
            }
            }.resume()
    }
    
    
    
    func postRateMovies(movieId: Int, sessionId: String,completion: @escaping (String) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_POST_RATE_MOVIES)/\(movieId)/rating?api_key=\(API.KEY)&session_id=\(sessionId)")!
        print(route)
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postRequest = [ "value": 8.5 ] as [String : Float]
        // print(requestToken)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postRequest, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            return
        }
        URLSession.shared.dataTask(with: request){(data , response, err) in
            guard let data = data else {return}
            do{
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try JSONDecoder().decode(PostRateListResponse.self, from: data)
                if data.status_code == 1{
                    completion(data.status_message)
                }
                
                //update
                if data.status_code == 12 {
                    completion(data.status_message)
                }
                print(data.status_message)
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
    }
    
    func postWatchList(movieId: Int,accountId : Int, sessionId: String,completion: @escaping (String) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_POST_WATCH_LIST)/\(accountId)/watchlist?api_key=\(API.KEY)&session_id=\(sessionId)")!
        print(route)
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postRequest: [String: Any] = [
            "media_type": "movie",
            "media_id": movieId,
            "watchlist": true
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postRequest, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            return
        }
        URLSession.shared.dataTask(with: request){(data , response, err) in
            guard let data = data else {return}
            do{
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try JSONDecoder().decode(PostWatchListResponse.self, from: data)
                if data.status_code == 1{
                    completion(data.status_message)
                }
                
                //update
                if data.status_code == 12 {
                    completion(data.status_message)
                }
                
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
    }
    
    func SearchMoviesByName(moviename : String, completion: @escaping (([MovieResponse]) -> Void) ){
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(moviename)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
            }.resume()
    }
    
}

extension MovieModel {
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode == 200 {
            guard let data = data else {
                print("\(TAG): empty data")
                return nil
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return result
            } else {
                print("\(TAG): failed to parse data")
                return nil
            }
        } else {
            print("\(TAG): Network Error - Code: \(response.statusCode)")
            return nil
        }
    }
}
