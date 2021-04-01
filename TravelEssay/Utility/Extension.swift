//
//  UITextField.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/23.
//

import UIKit

// MARK: - UITextField
extension UITextField {
    func underlined(placeholder: String, fieldColor: UIColor = UIColor.white) {
        
        borderStyle = .none
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
        border.backgroundColor = fieldColor.cgColor
        
        layer.addSublayer(border)
        
        textAlignment = .left
        textColor = UIColor.white
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: fieldColor])
    }
}

extension UIViewController {
    
    func makeAlert(title: String, message: String, buttonText: String = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default, handler: handler)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
