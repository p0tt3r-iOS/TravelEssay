//
//  FindPWViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/20.
//

import UIKit

class ResetPWViewController: UIViewController {
    // MARK: - Properties
    
    let resetPWViewModel = ResetPwViewModel()

    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - IBActions

    @IBAction func findPWButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField?.text else { return }
        
        if email.count == 0 {
            self.makeAlert(title: "에러", message: "이메일을 입력해주세요.")
        } else {
            resetPWViewModel.resetPassword(of: email) { result, error in
                guard error == nil else {
                    self.makeAlert(title: "에러", message: error!)
                    return
                }
                self.makeAlert(title: "비밀번호 재설정", message: "비밀번호 재설정 메일이 발송되었습니다.")
            }
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "비밀번호 찾기"
        emailTextField.underlined(placeholder: "Email")
    }
}
