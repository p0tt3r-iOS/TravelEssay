//
//  LoginViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/22.
//

import UIKit

import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin

class LoginViewModel: NSObject {
    weak var delegate: LoginDelegate?
    
    // MARK: - Email Login Method with Firebase 🔥
    
    func signInWithEmail(_ email: String, password: String) {
        // Server Login Method
        let login = LoginModel(email: email, password: password)
        APIManager.shared.callingLoginAPI(login: login) { succeed, error in
            if succeed {
                self.delegate?.loginSucceed()
            } else {
                self.delegate?.loginFailed(error: error)
            }
        }
        
        
//        // Firebase Login Method
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            guard error == nil else {
//                self.delegate?.loginFailed(error: error!)
//                return
//            }
//
//            self.delegate?.loginSucceed()
//        }
    }
    
    // MARK: - Pass Facebook Auth to Firebase
    
    func signInWithFacebook(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                self.delegate?.loginFailed(error: error!.localizedDescription)
                return
            }
            
            self.delegate?.loginSucceed()
        }
    }
    
    // MARK: - Kakao Login Methods
    
    func signInWithKakao() {
        // 카카오톡 설치 여부 확인 후 여부에 따라(카톡 앱/웹) 로그인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error == nil else {
                    self.delegate?.loginFailed(error: error!.localizedDescription)
                    return
                }
                
                self.delegate?.loginSucceed()
//                self.customAuthLogin(token: oauthToken!.accessToken)
//                커스텀 토큰 로그인 시도(JWT토큰 없이는 불가)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error == nil else {
                    self.delegate?.loginFailed(error: error!.localizedDescription)
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
                self.delegate?.loginFailed(error: error!.localizedDescription)
                return
            }
            
            self.delegate?.loginSucceed()
        }
    }
}

// MARK: - Facebook Login Methods

extension LoginViewModel: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else { return delegate!.loginFailed(error: error!.localizedDescription) }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        signInWithFacebook(with: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}

// MARK: - Google Login(GIDSignInDelegate) Methods

extension LoginViewModel: GIDSignInDelegate {
    func googleLogin() {
        // Configure the Google Sign In instance
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Start the sign in flow
        delegate?.configurePresentingVC()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { return delegate!.loginFailed(error: error.localizedDescription) }
        guard let authentication = user.authentication else { return delegate!.loginFailed(error: error.localizedDescription) }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else { return self.delegate!.loginFailed(error: error!.localizedDescription) }
            
            self.delegate!.loginSucceed()
        }
    }
}

// MARK: - Naver Login Methods

extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성공 시 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        delegate!.loginSucceed()
    }
    
    // 접근 토근 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 로그아웃 시 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        delegate!.loginFailed(error: error.localizedDescription)
    }
}
