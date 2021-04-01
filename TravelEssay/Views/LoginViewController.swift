//
//  LoginViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/18.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    // MARK: - Properties
    let loginViewModel = LoginViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        loginViewModel.login(with: emailTextField.text!, password: pwTextField.text!) { result, error in
            guard error == nil else {
                self.makeAlert(title: "에러", message: error!)
                return
            }
            
            self.performSegue(withIdentifier: "LoginSucceed", sender: self)
        }
    }
    @IBAction func signInGoogleButtonPressed(_ sender: UIButton) {
        googleLogin()
    }
    
    // MARK: - Methods
    func setUI() {
        // 밑줄만 남기고 텍스트 필드 출력
        emailTextField.underlined(placeholder: "Email")
        pwTextField.underlined(placeholder: "Password")
    }
    
    func setDelegate() {
        emailTextField.delegate = self
        pwTextField.delegate = self
    }
    
    
    func googleLogin() {
        // Configure the Google Sign In instance
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Start the sign in flow
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
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
            emailTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰에서 터치가 발생하면 End Editing(키보드가 내려감)
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else { return }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else {
                self.makeAlert(title: "에러", message: (error?.localizedDescription)!)
                return
            }
            self.performSegue(withIdentifier: "LoginSucceed", sender: self)
        }
    }
}
