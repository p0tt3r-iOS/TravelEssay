//
//  LoginModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/04/07.
//

import Foundation

struct LoginModel: Encodable {
    let email: String
    let password: String
}

struct LoginResponseModel: Codable {
    struct Data: Codable {
        let token: String
        let refreshToken: String
        let email: String
        let useridx: String
        let nickname: String
    }
    
    let success: Bool
    let data: Data?
    let message: String
}
