//
//  FindPWViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/24.
//

import UIKit
import Alamofire
import Firebase

class ResetPwViewModel {
    func resetPassword(of email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().useAppLanguage()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
}
