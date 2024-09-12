//
//  MainDetailTableCell.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 28/08/24.
//

import UIKit
import SDWebImage

class MainDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var bgRatingView: UIView!
    @IBOutlet weak var iconRatingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var gameDescTextView: UITextView!
    
    @IBOutlet weak var bgDateView: UIView!
    @IBOutlet weak var iconDateView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static let identifier = "MainDetailTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustTextViewHeight()
    }
    
    internal func setupData(game: Game) {
        activityIndicatorView.startAnimating()
        ratingLabel.text = "\(game.rating)"
        gameDescTextView.text = game.descriptionRaw
        gameTitleLabel.text = game.name
        dateLabel.text = game.released
        
        gameImageView.setImageWithLoadingIndicator(data: game.backgroundImage, loading: activityIndicatorView)
    }
    
    private func adjustTextViewHeight() {
        let contentSize = gameDescTextView.sizeThatFits(
            CGSize(
                width: gameDescTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)
        )
        var frame = gameDescTextView.frame
        frame.size.height = contentSize.height
        gameDescTextView.frame = frame
    }
    
    private func setupViews() {
        selectionStyle = .none
        gameImageView.setCornerRadius(amount: 24)
        bgRatingView.setCornerRadius(amount: 20)
        bgDateView.setCornerRadius(amount: 20)
        
        bgDateView.backgroundColor = UIColor(named: "BackgroundCard")
        bgRatingView.backgroundColor = UIColor(named: "BackgroundCard")
        
        bgDateView.setDropShadow()
        bgRatingView.setDropShadow()
        
        iconRatingImageView.image = UIImage(
            systemName: "star.fill")?.withTintColor(
                .systemYellow, renderingMode: .alwaysOriginal)
        iconDateView.image = UIImage(
            systemName: "calendar")?.withTintColor(
                UIColor(named: "Headline")!,
                renderingMode: .alwaysOriginal)
    }
}
