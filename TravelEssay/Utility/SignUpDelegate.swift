//
//  SignUpDelegate.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/04/07.
//

import Foundation

protocol SignUpDelegate: class {
    func signUpSucceed()
    func signUpFailed(error: String)
}
