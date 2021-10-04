//
//  Authentication.swift
//  ThermoCheck
//
//  Created by Gabriel Medeiros Pelegrino on 30/09/2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class Authentication {
    static let shared = Authentication()
    
    private init(){}
    
    func login(email: String, password: String, completion: @escaping (Bool)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
            if let err = err{
                print(err)
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func loginWithFacebook(completion: @escaping (Bool)->Void){
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, err) in
            if let err = err{
                print(err)
                completion(false)
            }else{
                guard result != nil else {return}
                completion(true)
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Bool, String)->Void){
        Auth.auth().createUser(withEmail: email,
                               password: password) { (result, err) in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }
            guard (result?.user) != nil else {
                completion(false, "No User")
                return
            }
            completion(true, "Done")
        }
    }
    
    fileprivate func routerToMain(_ viewController: UIViewController) {
        if viewController != viewController as? ChartViewController{
            Router.shared.toMain(viewController: viewController)
        }
    }
    
    func fetchCurrentUser(viewController: UIViewController){
        
        if let token = AccessToken.current, !token.isExpired {
            routerToMain(viewController)
        }else{
            if Auth.auth().currentUser != nil {
                // User is signed in.
                routerToMain(viewController)
            } else {
                // No user is signed in.
                signOut(viewController: viewController)
                Router.shared.toLogin(viewController: viewController)
            }
        }
    }
    
    func getCurrentuserID()->String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func signOut(viewController: UIViewController){
        do {
            try Auth.auth().signOut()
            let loginManager = LoginManager()
            loginManager.logOut()
            Router.shared.toLogin(viewController: viewController)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
