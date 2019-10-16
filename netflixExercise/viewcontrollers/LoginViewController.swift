//
//  LoginViewController.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
   
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
        
//                if NetworkUtils.checkReachable() == false {
//                    Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
//                    return
//                }
        
    }
    
    func setupNavigation(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "netflix.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }

   
    @IBAction func btnSignIn(_ sender: Any) {
        let username = txtUserName.text ?? ""
        let password = txtPassword.text ?? ""
        
        if username.isEmpty || password.isEmpty {
            displayMessage(usermessage: "Required for username or password")
            return
        }
        
        let myActivityIndicator = addActivityIndicator()
        
        UserModel.shared.RequestToken { (token) in
            print(token)
            let route = URL(string: "\(Routes.ROUTE_LOGIN)?api_key=\(API.KEY)")!
            var request = URLRequest(url: route)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let postRequest = ["username": username,
                               "password": password ,
                               "request_token": token] as [String : String]
           
            UserDefaults.standard.set(username, forKey: "username")
            
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: postRequest, options: .prettyPrinted)
            
            }catch let error {
                print(error.localizedDescription)
                self.displayMessage(usermessage: "Something went wrong.Please try again...")
                return
            }
           
            let response = URLSession.shared.dataTask(with: request) {(data, urlResponse, error) in
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                guard let data = data else {return}
                do{

                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    if let data = json {
                      let status = data["success"] as? Bool
                        if(status == true){
                            UserModel.shared.postSessionId(requestToken: token, completion: { (sessionId) in
                               // print(sessionId)
                                UserDefaults.standard.set(sessionId, forKey: "session")
                                UserDefaults.standard.synchronize()
                                
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                                    //vc?.sessionId = sessionId
                                    if let viewController = vc {
                                        self.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                }
                            })
                        }else{
                            self.displayMessage(usermessage: "Invalid request token")
                        }
                    }

                }catch let jsonErr {
                    print("error")
                    print(jsonErr)
                }

                }
                response.resume()
            
            
        }
    }
    
}

extension LoginViewController {
    func displayMessage(usermessage: String)-> Void{
        let alertController = UIAlertController(title: "Alert", message: usermessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addActivityIndicator() -> UIActivityIndicatorView {
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        return myActivityIndicator
    }
    
    func removeActivityIndicator(activityIndicator : UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
