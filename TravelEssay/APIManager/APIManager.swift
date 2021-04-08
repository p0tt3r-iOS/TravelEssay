//
//  APIManager.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/04/07.
//

import Foundation

import Alamofire

enum APIError: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIError>) -> Void

class APIManager {
    static let shared = APIManager()
    
    let decoder = JSONDecoder()
    
    func callingSignUpAPI(register: SignUpModel, completionHandler: @escaping (Bool, String) -> Void) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(Constants.signUp_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            debugPrint(response)
            
            guard let result = try? self.decoder.decode(SignUpResponseModel.self, from: response.data!) else {
                return completionHandler(false, "회원가입 결과 값을 받아오던 중 오류가 발생했습니다.")
            }
            guard result.data != nil else {
                return completionHandler(result.success, result.message)
            }
            
            completionHandler(result.success, result.message)
        }
    }
    
    func callingLoginAPI(login: LoginModel, completionHandler: @escaping (Bool, String) -> Void) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(Constants.login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            
            guard let result = try? self.decoder.decode(SignUpResponseModel.self, from: response.data!) else {
                return completionHandler(false, "로그인 결과 값을 받아오던 중 오류가 발생했습니다.")
            }
            guard result.data != nil else {
                return completionHandler(result.success, result.message)
            }
            
            completionHandler(result.success, result.message)
        }
    }
}
