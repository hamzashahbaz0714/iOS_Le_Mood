//
//  AuthService.swift
//  Posts App
//
//  Created by Hamza Shahbaz on 11/09/2019.
//  Copyright © 2019 Hamza Shahbaz. All rights reserved.
//

import Foundation

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func registerUserWithEmail(withEmail email: String, andPassword password: String,completion : @escaping CompletionHandlerWithError){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user?.user else {
                completion(false,error)
                return
            }
            completion(true,nil)
        }
    }
    
    
    //login Functions
    func loginUserWithEmail(email : String, password : String, completion : @escaping CompletionHandlerWithError){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil){
                completion(false,error)
                return
            }
            completion(true,nil)
        }
    }
    
    
}
