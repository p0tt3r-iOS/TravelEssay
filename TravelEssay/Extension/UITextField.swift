//
//  UITextField.swift
//  TravelEssay
//
//  Created by 하동훈 on 2021/03/23.
//

import UIKit

extension UITextField {
    func underlined(placeholder: String) {
        borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.width, height: 1)
        border.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(border)
        textAlignment = .left
        textColor = UIColor.white
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
