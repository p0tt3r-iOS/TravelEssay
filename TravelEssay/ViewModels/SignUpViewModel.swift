//
//  SignUpViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/24.
//

import UIKit
import Alamofire


class SignUpViewModel {
    
    // Login related properties
    var userToken = ""
    var objectID = ""
    var updatedLoginStatus = false
    
    // Register Error Message
    var errorMessage: String = ""
    
    // CompletionHandler를 통해, trySignUp이 완료된 후 클로져 내부 코드 실행
    func trySignUp(username: String, password: String,  completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let register = RegisterModel(id: username, password: password)
        
        APIManager.sharedInstance.callingRegisterAPI(register: register) { [self] result, failureCode in
            
            if result == true {
                let loginModel = LoginModel(login: register.id, password: register.password)
                
                APIManager.sharedInstance.callingLoginAPI(login: loginModel) {(result) in
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
                        // Login Failed
                        print(error.localizedDescription)
                    }
                }
                completionHandler(true)
            } else {
                switch failureCode {
                case "AE":
                    self.errorMessage = "이미 존재하는 계정입니다."
                case "LL":
                    self.errorMessage = "글자 수 입력을 초과하였습니다."
                default:
                    self.errorMessage = "알 수 없는 에러가 발생했습니다. 다시 시도 해주세요."
                }
                completionHandler(false)
            }
        }
    }
}
