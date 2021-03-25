//
//  APIManager.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import Foundation
import Alamofire

// MARK: - Login Error & CompletionHandler
enum APIErrors: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIErrors>) -> Void


class APIManager {
    
    static let sharedInstance = APIManager()
    
    // MARK: - Calling Register API
    func callingRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool, String?) -> ()) {
        
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            
            print("Debug print as follows: ")
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(RegisterResponseModel.self, from: data!)
                    print("json printing...\n", json)
                    if response.response?.statusCode == 200 {
                        completionHandler(true, nil)
                    } else {
                        let string = (json as AnyObject).value(forKey: "code") as? String
                        print("Success but error: \(string ?? "")")
                        completionHandler(false, string)
                    }
                } catch {
                    do {
                        let json = try JSONDecoder().decode(ErrorMessageModel.self, from: data!)
                        
                        switch json.code {
                        case 3033:
                            completionHandler(false, "AE")
                        case 8000:
                            completionHandler(false, "LL")
                        default:
                            completionHandler(false, "UE")
                        }
                    } catch {
                        print(error.localizedDescription)
                        completionHandler(false, "NI")
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false, "NI")
            }
        }
    }
    
    // MARK: - Calling Login API
    func callingLoginAPI(login: LoginModel, completionHandler: @escaping Handler) {
        
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            
            print("Debug print as follow: ")
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                print("Hey Succeeded")
                
                do {
                    let json = try JSONDecoder().decode(LoginResponseModel.self, from: data!)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "ETC")))
                    }
                } catch {
                    do {
                        let json = try JSONDecoder().decode(ErrorMessageModel.self, from: data!)
                        print("json msg: \(json.message)")
                        print("json code: \(json.code)")
                        
                        if json.code == 3003 {
                            completionHandler(.failure(.custom(message: "IPE")))
                        } else {
                            completionHandler(.failure(.custom(message: "ETCLE")))
                        }
                    } catch {
                        print(error.localizedDescription)
                        completionHandler(.failure(.custom(message: "NP")))
                    }
                }
                
            case .failure(let error):
                print("Hey Failed")
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "NI")))
            }
        }
    }
    
    // MARK: - Send Set Password Again API Call
    func callingResetLoginAPI(id: String, completionHandler: @escaping (Bool, String) -> ()) {
        
        AF.request("\(base_url)/restorepassword/\(id)", method: .get, parameters: nil, headers: nil).response { response in
            
            switch response.result {
            case .success(let data):
                if response.response?.statusCode == 200 {
                    completionHandler(true, "")
                } else {
                    do {
                        let json = try JSONDecoder().decode(ErrorMessageModel.self, from: data!)
                        let code = json.code
                        if code == 3020 {
                            completionHandler(false, "UNF")
                        } else {
                            completionHandler(false, "UNK")
                        }
                    } catch {
                        completionHandler(false, "UNK")
                    }
                }
            case .failure(let error):
                print("Error While Password Reset API Call: \(error.localizedDescription)")
                completionHandler(false, "NNC")
            }
        }
    }
    
    // https://api.backendless.com/<application-id>/<REST-api-key>/users/restorepassword/<user-identity-property>  <- id
        /* error msg in json
     {
       "message":error-message,
       "code":error-code
     }
     2002
     Version is disabled or provided wrong application info (application id or secret key)
     3020
     Unable to find user with the specified login (invalid user identity).
     3025
     General password recovery error. Additional details should be available in the "message" property of the response.
     3038
     One of the requirement arguments (application id, version or user identity) is missing.
     */
    
}
