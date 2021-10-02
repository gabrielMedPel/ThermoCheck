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
                completion(true)

            }
        }
    }
        
    func register(email: String, password: String, username: String, completion: @escaping (Bool, String)->Void){
        Auth.auth().createUser(withEmail: email,
                               password: password) { (result, err) in
            if let err = err{
               completion(false, err.localizedDescription)
                return
            }

            guard let user = result?.user else {
                completion(false, "No User")
                return
            }
             //user profile additional info:
            let profileChangeReqeust = user.createProfileChangeRequest()
            profileChangeReqeust.displayName = username
            
            profileChangeReqeust.commitChanges { (error) in
                if let error = error {
                    //change name failed
                   completion(false, error.localizedDescription)
                }else {
                    completion(true, "Done")
                }
            }
        }
    }
    
    func fetchCurrentUser(viewController: UIViewController){
        if let token = AccessToken.current, !token.isExpired {
            Router.shared.toMain(viewController: viewController)
        }else{
            if Auth.auth().currentUser != nil {
              // User is signed in.
                Router.shared.toMain(viewController: viewController)
            } else {
              // No user is signed in.
                Router.shared.toLogin(viewController: viewController)
            }
        }
        
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
