//
//  UIView+Extension.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 30/08/24.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(amount: CGFloat) {
        self.layer.cornerRadius = amount
        self.clipsToBounds = true
    }
    
    func setDropShadow() {
        // Drop Shadow
        self.layer.masksToBounds = false // Important to allow shadows to be drawn outside bounds
        self.layer.shadowOffset = CGSize(width: 0, height: 10) // Adjust for vertical shadow
        self.layer.shadowRadius = 24 // Adjust radius for how blurred the shadow is
        
        if traitCollection.userInterfaceStyle == .dark {
            self.layer.shadowColor = UIColor.white.cgColor
            self.layer.shadowOpacity = 0.08
        } else {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.08
        }
        
    }
}
