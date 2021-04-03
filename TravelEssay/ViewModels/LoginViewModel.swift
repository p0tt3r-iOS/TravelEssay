//
//  LoginViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import UIKit

import Firebase
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewModel {
    weak var delegate: LoginDelegate?
    
    // MARK: - Firebase 🔥
    
    func signInWithEmail(_ email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.delegate?.loginFailed(error: error!)
                return
            }
            self.delegate?.loginSucceed()
        }
    }
    
    // MARK: - Facebook with Firebase
    
    func signInWithFacebook(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else { self.delegate?.loginFailed(error: error!)
                return
            }
            self.delegate?.loginSucceed()
        }
    }
    
    // MARK: - Kakao
    
    func signInWithKakao() {
        // 카카오톡 설치 여부 확인 후 여부에 따라(카톡 앱/웹) 로그인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error == nil else {
                    self.delegate?.loginFailed(error: error!)
                    return
                }
                self.delegate?.loginSucceed()
//                self.customAuthLogin(token: oauthToken!.accessToken)
//                커스텀 토큰 로그인 시도(JWT토큰 없이는 불가)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error == nil else {
                    self.delegate?.loginFailed(error: error!)
                    return
                }
                self.delegate?.loginSucceed()
//                self.customAuthLogin(token: oauthToken!.accessToken)
//                커스텀 토큰 로그인 시도(JWT토큰 없이는 불가)
            }
        }
    }
    
    private func customAuthLogin(token: String) {
        Auth.auth().signIn(withCustomToken: token) { result, error in
            guard error == nil else {
                self.delegate?.loginFailed(error: error!)
                return
            }
            self.delegate?.loginSucceed()
        }
    }

}
    


