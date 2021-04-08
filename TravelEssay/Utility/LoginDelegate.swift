//
//  LoginDelegate.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/04/02.
//

import UIKit

/// Delegate for signaling that login has done successfully.
protocol LoginDelegate: NSObject {
    func loginSucceed()
    func loginFailed(error: String)
    func configurePresentingVC()
}
