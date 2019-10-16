//
//  UserModel.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation

class UserModel{
    static let shared = UserModel()
    private init(){}
    
    
    func RequestToken(completion: @escaping (String) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_REQUEST_TOKEN)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route){(data , response, err) in
            guard let data = data else {return}
            do{
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
               
                let data = try
                  
                JSONDecoder().decode(UserResponse.self, from: data)
               // print(data.request_token!)
                completion(data.request_token!)
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
    }
    
    
    func postSessionId(requestToken:String,completion: @escaping (String) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_SESSION_ID)?api_key=\(API.KEY)")!
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postRequest = [ "request_token": requestToken] as [String : String]
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
                
                let data = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(data.session_id!)
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
    }
    
    
    func getAccount(sessionId:String,completion: @escaping (UserAccountResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_ACCOUNT)?api_key=\(API.KEY)")!
        var request = URLRequest(url: route)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let getRequest = [ "session_id": sessionId] as [String : String]
   
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: getRequest, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            return
        }
        URLSession.shared.dataTask(with: request){(data , response, err) in
            guard let data = data else {return}
            do{
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try JSONDecoder().decode(UserAccountResponse.self, from: data)
                completion(data)
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
    }
    
    
    
}
/*
extension UserModel {
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
*/
