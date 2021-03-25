//
//  FindPWViewModel.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/24.
//

import UIKit
import Alamofire

class FindPwViewModel {
    
    var idErrorLabelColor: UIColor = .clear
    var alertTitle = "오류"
    var alertMessage = ""
    
    func tryFindPassword(username: String) {
        
        // 구조체로 구현하면 클로저 내에서 구조체 인스턴스를 변경할 수 없는데, 어떻게 해야할까?
        APIManager.sharedInstance.callingResetLoginAPI(id: username) { [self] result, failureCode in
            
            if result == true {
                self.alertTitle = "알림"
                self.alertMessage = "새로 발급된 비밀번호를 이메일로 발송하였습니다."
            } else {
                switch failureCode {
                case "UNF":
                    self.alertMessage = "등록되지 않은 아이디 입니다."
                case "UNK":
                    self.alertMessage = "프로그램에 오류가 발생했습니다."
                case "NNC":
                    self.alertMessage = "네트워크 또는 아이디 양식을 확인해주세요."
                default:
                    break
                }
            }
        }
    }
}
