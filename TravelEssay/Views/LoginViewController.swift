//
//  LoginViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/18.
//

import UIKit

import GoogleSignIn
import FBSDKLoginKit
import NaverThirdPartyLogin

class LoginViewController: UIViewController {
    // MARK: - Properties
    let vm = LoginViewModel()
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signInGoogleButton: UIButton!
    @IBOutlet weak var signInNaverButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        vm.signInWithEmail(emailTextField.text!, password: pwTextField.text!)
    }
    
    @IBAction func signInGoogleButtonPressed(_ sender: UIButton) {
        vm.googleLogin()
    }
    
    @IBAction func signInKakaoButtonPressed(_ sender: UIButton) {
        vm.signInWithKakao()
    }
    
    @IBAction func signInNaverButtonPressed(_ sender: UIButton) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    // MARK: - Methods
    private func setUI() {
        // 밑줄만 남기고 텍스트 필드 출력
        emailTextField.underlined(placeholder: "Email")
        pwTextField.underlined(placeholder: "Password")
        addFacebookLoginButton()
    }
    
    private func setDelegate() {
        emailTextField.delegate = self
        pwTextField.delegate = self
        vm.delegate = self
        loginInstance?.delegate = vm
    }
    
    private func addFacebookLoginButton() {
        let loginButton = FBLoginButton()
        loginButton.layer.cornerRadius = 14
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.delegate = vm
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: signInNaverButton.bottomAnchor, constant: 8),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: signInGoogleButton.widthAnchor)
        ])
    }
    
    private func alignSignInLogo(of button: UIButton) {
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

// MARK: - LoginDelegate Method

extension LoginViewController: LoginDelegate {
    func loginSucceed() {
        self.performSegue(withIdentifier: "LoginSucceed", sender: self)
    }
    
    func loginFailed(error: String) {
        makeAlert(title: "로그인 실패", message: error)
    }
    
    func configurePresentingVC() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
}
