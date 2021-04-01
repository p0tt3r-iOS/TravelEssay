//
//  LoginViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewModel {
    // MARK: - Firebase 🔥
    
    func login(with email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }

}
    

    
