//
//  ViewController.swift
//  socialApp
//
//  Created by Gökhan Sayılgan on 09/05/17.
//  Copyright © 2017 Gökhan Sayılgan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper 

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Gökhan: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
   

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
       let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Gökhan: unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Gökhan: User cancelled Facebook authentication")
            } else {
                print("Gökhan: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential) 
            }
        }
    }

    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print("Gökhan: unable to authenticate with Firebase - \(error)")
            } else {
                print("Gökhan: Successfully authenticated with Firebase ")
                if let user = user {
                    let userData = ["provider": credential.provider ]
                  self.completeSignIn(id: user.uid, userData: userData )
                }
                
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    
                    print("Gökhan: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID ]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Gökhan: Unable to authenticate with Firebase using email")
                        } else {
                            print("Gökhan: Succesfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID ]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBUsers(uid: id, userData: userData)
       let keychainResult =  KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Gökhan: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

