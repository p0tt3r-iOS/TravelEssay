//
//  FindPWViewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/20.
//

import UIKit

class FindPWViewController: UIViewController {
    // MARK: - Properties
    let findPWViewModel = FindPwViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var idErrorLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func idTextFieldEditingDidBegin(_ sender: UITextField) {
        idTextField.underlined(placeholder: "UserID")
        idErrorLabel.textColor = .clear
    }
    
    @IBAction func findPWButtonPressed(_ sender: UIButton) {
        guard let username = idTextField?.text else { return }
        
        if username.count == 0 {
            idErrorLabel.textColor = .red
        } else {
            findPWViewModel.tryFindPassword(username: username)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.makeAlert(title: self.findPWViewModel.alertTitle, message: self.findPWViewModel.alertMessage)
            }
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "비밀번호 찾기"
        idTextField.underlined(placeholder: "UserID", fieldColor: UIColor.red)
    }
}
