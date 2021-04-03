//
//  LoginViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/18.
//

import UIKit

import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    let vm = LoginViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signInGoogleButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        vm.signInWithEmail(emailTextField.text!, password: pwTextField.text!)
    }
    
    @IBAction func signInGoogleButtonPressed(_ sender: UIButton) {
        googleLogin()
    }
    
    @IBAction func signInKakaoButtonPressed(_ sender: UIButton) {
        vm.signInWithKakao()
    }
    
    // MARK: - Methods
    func setUI() {
        // 밑줄만 남기고 텍스트 필드 출력
        emailTextField.underlined(placeholder: "Email")
        pwTextField.underlined(placeholder: "Password")
        addFacebookLoginButton()
    }
    
    func setDelegate() {
        emailTextField.delegate = self
        pwTextField.delegate = self
        vm.delegate = self
    }

    
    func googleLogin() {
        // Configure the Google Sign In instance
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Start the sign in flow
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func alignSignInLogo(of button: UIButton) {
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.leadingAnchor.constraint(equalTo: signInGoogleButton.leadingAnchor, constant: 24).isActive = true
        button.imageView?.centerYAnchor.constraint(equalTo: signInGoogleButton.centerYAnchor).isActive = true
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        
        alignSignInLogo(of: signInGoogleButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "로그인"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
}

// MARK: - Text Field Delegate Methods

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder, pwTextField.text!.isEmpty {
            pwTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰에서 터치가 발생하면 End Editing(키보드가 내려감)
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - GIDSignInDelegate Methods

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { return self.makeAlert(title: "에러", message: error.localizedDescription)}
        
        guard let authentication = user.authentication else { return self.makeAlert(title: "에러", message: error.localizedDescription)}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else { return self.makeAlert(title: "에러", message: (error?.localizedDescription)!) }
            self.loginSucceed()
        }
    }
}

// MARK: - Section Heading

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            loginFailed(error: error!)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        vm.signInWithFacebook(with: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    
    func addFacebookLoginButton() {
        let loginButton = FBLoginButton()
        loginButton.layer.cornerRadius = 14
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: signInGoogleButton.bottomAnchor, constant: 63),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 47),
            loginButton.widthAnchor.constraint(equalTo: signInGoogleButton.widthAnchor)
        ])
    }
}

// MARK: - LoginDelegate Method

extension LoginViewController: LoginDelegate {
    func loginSucceed() {
        self.performSegue(withIdentifier: "LoginSucceed", sender: self)
    }
    
    func loginFailed(error: Error) {
        makeAlert(title: "로그인 실패", message: error.localizedDescription)
    }
}
