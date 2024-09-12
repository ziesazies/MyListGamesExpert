//
//  UIImageView+Extension.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 09/09/24.
//

import UIKit

extension UIImageView {
    func setImageWithLoadingIndicator(data: String, loading: UIActivityIndicatorView) {
        self.sd_setImage(with: URL(string: data)) { [weak self] _, error, _, _ in
            guard let self = self else { return }
            
            loading.stopAnimating()
            loading.isHidden = true
            if error != nil {
                self.image = UIImage(systemName: "gamecontroller")
            }
        }
    }
    
}
