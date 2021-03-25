//
//  RegisterModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import Foundation

struct RegisterModel: Encodable {
    
    let id: String
    let password: String
    
}

// MARK: - Register Response Model
// NULL을 받는 정수(변수)는 Optional로 선언한다.
struct RegisterResponseModel: Codable {
    
    let lastLogin: Int?
    let userStatus: String
    let created: Int
    let welcomeClass, blUserLocale, id: String
    let ownerID: String
    let socialAccount: String?
    let objectID: String
    
    enum CodingKeys: String, CodingKey {
        case lastLogin, userStatus, created
        case welcomeClass = "___class"
        case blUserLocale, id
        case ownerID = "ownerId"
        case socialAccount
        case objectID = "objectId"
    }
}

