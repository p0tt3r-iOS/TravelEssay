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
    
    func callingSignUpAPI(register: SignUpModel, completionHandler: @escaping (Bool, String) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(Constants.signUp_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            let decoder = JSONDecoder()
            
            guard let result = try? decoder.decode(SignUpResponseModel.self, from: response.data!) else { return }
            
            guard result.data != nil else {
                return completionHandler(result.success, result.message)
            }
            
            print(result.success)
            print(result.message)
            print(result.data)
            completionHandler(result.success, result.message)
            
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//
//                guard let response = try? decoder.decode(SignUpResponseModel.self, from: data! as! Data) else {
//                    return completionHandler(false, "네트워크 응답 오류")
//                }
//                completionHandler(response.success, response.message)
//            case .failure(let error):
//                print(error.localizedDescription)
//                completionHandler(false, "회원가입을 실패했습니다")
//            }
        }
    }
    
    func callingLoginAP(login: LoginModel, completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(Constants.login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            debugPrint(response)
            
            switch response.result{
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(LoginResponseModel.self, from: data!)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "네트워크 연결을 확인하세요.")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "다시 시도해주세요.")))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(.failure(.custom(message: "다시 시도해주세요.")))
            }
        }
    }
}
