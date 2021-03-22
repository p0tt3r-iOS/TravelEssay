//
//  LoginModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import Foundation
import UIKit

struct LoginModel: Encodable {
    let login: String
    let password: String
}

// MARK: - Login Response Model
struct LoginResponseModel: Codable {
    let lastLogin: Int
    let userStatus: String
    let created: Int
    let welcomeClass, blUserLocale, id, userToken: String
    let ownerID, socialAccount: String
    let objectID: String
    
    enum CodingKeys: String, CodingKey {
        case lastLogin, userStatus, created
        case welcomeClass = "___class"
        case blUserLocale, id
        case userToken = "user-token"
        case ownerID = "ownerId"
        case socialAccount
        case objectID = "objectId"
    }
}

struct ErrorMessageModel: Codable {
    let message: String
    let code: Int
}
