//
//  SignUpViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/24.
//

import UIKit
import Alamofire
import Firebase


class SignUpViewModel {
    // MARK: - Firebase 🔥

    func createUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
}
