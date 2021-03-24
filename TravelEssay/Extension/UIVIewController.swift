//
//  UIVIewController.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/24.
//

import UIKit

extension UIViewController {
    
    func makeAlert(title: String, message: String, buttonText: String = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default, handler: handler)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
