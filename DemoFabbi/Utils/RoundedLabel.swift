//
//  RoundedLabel.swift
//  DemoFabbi
//
//  Created by tientm on 02/02/2024.
//

import UIKit

@IBDesignable
final class RoundedLabel: UILabel {
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWitdh: CGFloat {
        set {
            layer.borderColor = UIColor.lightGray.cgColor
            layer.borderWidth = newValue
        }
        get {
            layer.borderWidth
        }
    }
}
