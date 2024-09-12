//
//  GenreDetailTableCell.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 28/08/24.
//

import UIKit

class GenreDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var nameGenreLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static let identifier = "GenreDetailTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        activityIndicatorView.startAnimating()
        genreImageView.contentMode = .scaleAspectFill
        genreImageView.setCornerRadius(amount: 15)
    }
    
    internal func setupData(name: String, picture: String) {
        nameGenreLabel.text = name
        
        genreImageView.setImageWithLoadingIndicator(data: picture, loading: activityIndicatorView)
    }
    
}
