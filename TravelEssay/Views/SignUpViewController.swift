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
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var cfPwTextField: UITextField!
    @IBOutlet weak var idErrorLabel: UILabel!
    @IBOutlet weak var pwErrorLabel: UILabel!
    @IBOutlet weak var cfPwErrorLabel: UILabel!
    
    // MARK: - Methods
    func setUI() {
        idTextField.underlined(placeholder: "UserID")
        pwTextField.underlined(placeholder: "Password")
        cfPwTextField.underlined(placeholder: "Confirm Password")
        idErrorLabel.textColor = .clear
        pwErrorLabel.textColor = .clear
        cfPwErrorLabel.textColor = .clear
    }
    
    func checkTextField() -> Bool {
        
        var pass = true
        
        if (idTextField.text?.count ?? 0) == 0 {
            idErrorLabel.text = "아이디가 입력되지 않았습니다."
            idErrorLabel.textColor = .red
            pass = false
        }
        
        if (pwTextField.text?.count ?? 0) == 0 {
            pwErrorLabel.text = "비밀번호가 입력되지 않았습니다."
            pwErrorLabel.textColor = .red
            pass = false
        }
        
        if (cfPwTextField.text?.count ?? 0) == 0 {
            cfPwErrorLabel.text = "비밀번호 확인이 입력되지 않았습니다."
            cfPwErrorLabel.textColor = .red
            pass = false
        }
        
        return pass
    }
    
    func checkPassword() -> Bool {
        
        if pwTextField.text != cfPwTextField.text {
            cfPwErrorLabel.text = "비밀번호가 일치하지 않습니다."
            
            return false
        }
        return true
    }
    
    func dismissErrorLabel() {
        idErrorLabel.textColor = .clear
        pwErrorLabel.textColor = .clear
        cfPwErrorLabel.textColor = .clear
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        dismissErrorLabel()
        
        let validTextField = checkTextField()
        let samenessOfPassword = checkPassword()
        
        if !validTextField {
            return
        }
        
        if !samenessOfPassword {
            return
        }
        
        signUpViewModel.trySignUp(username: self.idTextField.text!, password: self.pwTextField.text!) { success in
            if success {
                self.performSegue(withIdentifier: "signUpSucceed", sender: self)
            } else {
                self.cfPwErrorLabel.text = self.signUpViewModel.errorMessage
                self.cfPwErrorLabel.textColor = .red
            }
        }

    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "회원가입"
        setUI()
    }
    

 

}


