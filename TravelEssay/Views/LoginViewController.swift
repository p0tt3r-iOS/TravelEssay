//
//  LoginViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/18.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let loginViewModel = LoginViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var idErrorLabel: UILabel!
    @IBOutlet weak var pwErrorLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let loginGroup = DispatchGroup()
        
        DispatchQueue.main.async(group: loginGroup) {
            self.loginViewModel.tryLogin(username: self.idTextField.text!, password: self.pwTextField.text!)
        }
        
        // tryLogin 함수가 끝나기 전에 아래 내용이 실행되는 것을 방지하기 위해 asyncAfter 함수 사용)
        // Network Duration이 1.5초 이상 소모되면, 실행되지 않음
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        
        // Dispatch Group을 통해, 그룹 내 모든 작업이 종료되면 실행(작동하지 않음...)
        // loginGroup.notify(queue: DispatchQueue.main) {
            
            self.idErrorLabel.text = self.loginViewModel.idError
            self.idErrorLabel.textColor = self.loginViewModel.idErrorLabelColor
            self.pwErrorLabel.text = self.loginViewModel.pwError
            self.pwErrorLabel.textColor = self.loginViewModel.pwErrorLabelColor
            
            // LoginStauts가 true일 경우, 다음 화면으로
            if self.loginViewModel.updatedLoginStatus {
                self.performSegue(withIdentifier: "LoginSucceed", sender: self)
            }
        }
        
    }
    
    // MARK: - Methods
    func setUI() {
        // 밑줄만 남기고 텍스트 필드 출력
        idTextField.underlined(placeholder: "UserID")
        pwTextField.underlined(placeholder: "Password")
        // 최초 화면에서 Error Label 숨김(로그인 에러가 발생했을 때 표시)
        idErrorLabel.textColor = .clear
        pwErrorLabel.textColor = .clear
    }
    
    func setDelegate() {
        idTextField.delegate = self
        pwTextField.delegate = self
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
        // return 버튼 클릭 시 키보드가 내려간다.(텍스트 필드의 현재 상태를 포기)
        idTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 뷰에서 터치가 발생하면 End Editing(키보드가 내려감)
        self.view.endEditing(true)
    }
}

