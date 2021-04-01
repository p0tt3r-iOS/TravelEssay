//
//  SignUpViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/20.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - Properties
    let signUpViewModel = SignUpViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var cfPwTextField: UITextField!
    
    // MARK: - Methods
    func setUI() {
        emailTextField.underlined(placeholder: "Email")
        pwTextField.underlined(placeholder: "Password")
        cfPwTextField.underlined(placeholder: "Confirm Password")
    }
    
    func checkTextField() -> Bool {
        if (emailTextField.text?.count ?? 0) == 0 {
            makeAlert(title: "에러", message: "이메일이 입력되지 않았습니다.")
            return false
        }
        if (pwTextField.text?.count ?? 0) == 0 {
            makeAlert(title: "에러", message: "비밀번호가 입력되지 않았습니다.")
            return false
        }
        
        return true
    }
    
    func checkPassword() -> Bool {
        if pwTextField.text != cfPwTextField.text {
            makeAlert(title: "에러", message: "비밀번호가 일치하지 않습니다.")
            return false
        }
        
        return true
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard checkTextField() else { return }
        guard checkPassword() else { return }
        
        signUpViewModel.createUser(email: self.emailTextField.text!, password: self.pwTextField.text!) { result, error in
            guard error == nil else {
                self.makeAlert(title: "에러", message: error!)
                return
            }
            
            self.performSegue(withIdentifier: "signUpSucceed", sender: self)
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "회원가입"
        setUI()
    }
}

// MARK: - Text Field Delegate Methods
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder, pwTextField.text!.isEmpty {
            pwTextField.becomeFirstResponder()
        } else if cfPwTextField.text!.isEmpty {
            cfPwTextField.becomeFirstResponder()
        } else {
            if emailTextField.isFirstResponder {
                emailTextField.resignFirstResponder()
            } else if pwTextField.isFirstResponder {
                pwTextField.resignFirstResponder()
            } else {
                cfPwTextField.resignFirstResponder()
            }
            
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰에서 터치가 발생하면 End Editing(키보드가 내려감)
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


