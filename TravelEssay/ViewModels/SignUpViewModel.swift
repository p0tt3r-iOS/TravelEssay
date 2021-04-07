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
    weak var delegate: SignUpDelegate?
    
    // MARK: - Firebase 🔥

    func createUser(email: String, password: String) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            guard error == nil else {
//                completion(false, error?.localizedDescription)
//                return
//            }
//            completion(true, nil)
//        }
        
        let register = SignUpModel(email: email, password: password, provider: "N", token: "testtoken", nickname: "nick")
        
        // Server Sign Up
        APIManager.shared.callingSignUpAPI(register: register) { succeed, error in
            if succeed {
                self.delegate?.signUpSucceed()
            } else {
                self.delegate?.signUpFailed(error: error)
            }
        }
    }
    
}
