//
//  LoginViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import UIKit
import Alamofire

class LoginViewModel {

    var userToken = ""
    var objectID = ""
    var updatedLoginStatus = false
    
    var idError: String = "아이디가 입력되지 않았습니다."
    var idErrorLabelColor: UIColor = .clear
    var pwError: String = "비밀번호가 입력되지 않았습니다."
    var pwErrorLabelColor: UIColor = .clear
    
    func tryLogin(username: String, password: String) {
        idErrorLabelColor = .clear
        pwErrorLabelColor = .clear
        
        if username.isEmpty {
            idError = "아이디가 입력되지 않았습니다."
            idErrorLabelColor = .red
            if password.isEmpty {
                pwError = "비밀번호가 입력되지 않았습니다."
                pwErrorLabelColor = .red
                return
            }
            return
        }
        
        if password.isEmpty {
            pwError = "비밀번호가 입력되지 않았습니다."
            pwErrorLabelColor = .red
            return
        }
        
        let loginModel = LoginModel(login: username, password: password)
        
        APIManager.sharedInstance.callingLoginAPI(login: loginModel) { (result) in
            switch result {
            // Login Completion Handler
            case .success(let json):
                // Login Succeeded
                _ = (json as! LoginResponseModel).id
                self.updatedLoginStatus = true
                // Keep objectID, userToken
                self.userToken = (json as! LoginResponseModel).userToken
                self.objectID = (json as! LoginResponseModel).objectID
                // Save userToken, objectID in user defaults
                UserDefaults.standard.set(self.userToken, forKey: "UserToken")
                UserDefaults.standard.set(self.objectID, forKey: "ObjectID")
                
            case .failure(let error):
                if case .custom(let value) = error {
                    if value == "IPE" {
                        self.pwError = "아이디 또는 비밀번호가 일치하지 않습니다."
                        self.pwErrorLabelColor = .red
                    } else if value == "NI" {
                        self.pwError = "인터넷이 연결되어 있지 않습니다. 로그인 시 인터넷 연결이 필요합니다."
                        self.pwErrorLabelColor = .red
                    } else if value == "ETCLE" {
                        self.pwError = "알 수 없는 에러가 발생했습니다. 다시 로그인 해주세요."
                        self.pwErrorLabelColor = .red
                    } else if value == "NP" {
                        self.pwError = "서비스에 오류가 발생했습니다. 제작자에게 리포트 해주세요."
                        self.pwErrorLabelColor = .red
                    }
                }
            }
        }
    }
}
    
    
