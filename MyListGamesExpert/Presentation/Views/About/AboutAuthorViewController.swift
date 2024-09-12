//
//  AboutAuthorViewController.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 28/08/24.
//

import UIKit

class AboutAuthorViewController: UIViewController {
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var authorBioLabel: UILabel!
    @IBOutlet weak var authorNameLabe: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        authorImageView.image = UIImage(named: "author")
        authorNameLabe.text = "Alief Ahmad Azies"
        authorBioLabel.text = "Soon to be professional iOS Developer"
    }
}
