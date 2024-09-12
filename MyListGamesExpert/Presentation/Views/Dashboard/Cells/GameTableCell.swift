//
//  GameTableCell.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 26/08/24.
//

import UIKit

class GameTableCell: UITableViewCell {
    
    static let identifier = "GameTableCell"
    
    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var gameReleasedDateLabel: UILabel!
    
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        activityIndicatorView.startAnimating()
        
        /// color
        contentView.backgroundColor = UIColor(named: "Background")
        bgView.backgroundColor = UIColor(named: "BackgroundCard")
        gameNameLabel.textColor = UIColor(named: "Headline")
        gameReleasedDateLabel.textColor = UIColor(named: "Headline")
        gameRatingLabel.textColor = UIColor(named: "Body")
        
        bgView.setDropShadow()
        bgView.setCornerRadius(amount: 32)
        gameImageView.setCornerRadius(amount: 24)
    }
    
    func configCell(game: Game) {
        gameNameLabel.text = game.name
        gameReleasedDateLabel.text = game.released
        gameRatingLabel.text = "\(game.rating)"
        
        gameImageView.setImageWithLoadingIndicator(data: game.backgroundImage, loading: activityIndicatorView)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupView()
    }
    
}
