//
//  Extension.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 20.10.2021.
//

import Foundation
import UIKit

extension UITextField {
    convenience init(placeholder: String, backgroundColor: UIColor = UIColor(white: 0, alpha: 0.03), borderStyle: BorderStyle = .roundedRect, font: UIFont = UIFont.systemFont(ofSize: 14)) {
        self.init()
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        self.font = font
    }
}
