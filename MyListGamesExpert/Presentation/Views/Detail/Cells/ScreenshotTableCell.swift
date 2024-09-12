//
//  ScreenshotsTableCell.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 28/08/24.
//

import UIKit

class ScreenshotTableCell: UITableViewCell {
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static let identifier = "Screenshot"
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        screenshotImageView.contentMode = .scaleAspectFill
        selectionStyle = .none
        screenshotImageView.setCornerRadius(amount: 8)
    }
    
    internal func setupScreenshot(url image: String) {
        // Start activity indicator before loading the image
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        screenshotImageView.setImageWithLoadingIndicator(data: image, loading: activityIndicatorView)
    }
}
