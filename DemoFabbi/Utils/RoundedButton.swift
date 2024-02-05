//
//  RoundedButton.swift
//  DemoFabbi
//
//  Created by tientm on 04/02/2024.
//

import Foundation

import UIKit

@IBDesignable
final class  RounedButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set  {
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
}
