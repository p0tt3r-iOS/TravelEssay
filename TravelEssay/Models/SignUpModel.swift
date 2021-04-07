//
//  RegisterModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/04/07.
//

import Foundation

struct SignUpModel: Encodable {
    let email: String
    let password: String
    let provider: String
    let token: String
    let nickname: String
}

struct SignUpResponseModel: Codable {
    struct Data: Codable {
        let email: String
        let useridx: Int
    }
    
    let success: Bool
    let data: Data?
    let message: String
}
