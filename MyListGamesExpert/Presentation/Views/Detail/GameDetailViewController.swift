//
//  GameDetailViewController.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 26/08/24.
//

import UIKit
import RxSwift

enum GameDetailSection: Int, CaseIterable {
    case mainDetail
    case genres
    case screenshots
    
    static func numberOfSections() -> Int {
        return self.allCases.count
    }
}

class GameDetailViewController: UIViewController {
    
    // MARK: - private
    private var disposeBag = DisposeBag()
    private var game: Game?
    private lazy var tableView = UITableView(frame: CGRectNull, style: .grouped)
    
    // MARK: - public
    internal var id: Int = 0
    internal var isFromFavorites: Bool = false
    var viewModel: GameDetailViewModel
    
    init(viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBarButtonItem()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.gameDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] game in
                self?.game = game
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isFavorite
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFavorite in
                self?.updateFavoriteButton(isFavorite: isFavorite)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showError(message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchGameDetail(id: id)
        
        viewModel.checkIfFavorite(id: id)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let barButtonItem: UIBarButtonItem
        if isFavorite {
            barButtonItem = UIBarButtonItem(
                title: "",
                image: UIImage(systemName: "trash.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal),
                target: self,
                action: #selector(deleteButtonTapped(_:))
            )
        } else {
            barButtonItem = UIBarButtonItem(
                title: "",
                image: UIImage(systemName: "heart.fill"),
                target: self,
                action: #selector(addButtonTapped(_:))
            )
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func deleteButtonTapped(_ sender: Any) {
        guard let game = self.game else { return }
        
        let alert = UIAlertController(
            title: "Delete Favorite",
            message: "Do you want to delete this game from your favorites?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            self?.viewModel.removeGameFromFavorite(id: game.id)
            let successAlert = UIAlertController(
                title: "Success",
                message: "Your favorite games has been deleted",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(successAlert, animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    @objc func addButtonTapped(_ sender: Any) {
        guard let game = self.game else { return }
        viewModel.checkIfFavorite(id: game.id)
        viewModel.isFavorite
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] isFavorite in
                if isFavorite {
                    let alert = UIAlertController(
                        title: "Already in Favorites",
                        message: "This game is already in your favorite list.",
                        preferredStyle: .alert
                    )
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: nil)
                    )
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(
                        title: "Add Favorite",
                        message: "Do you want to favorite this game?",
                        preferredStyle: .alert
                    )
                    
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                        self?.viewModel.addToFavorite(game: game)
                        let successAlert = UIAlertController(
                            title: "Saved",
                            message: "The game has been added to your favorites.",
                            preferredStyle: .alert
                        )
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                            self?.navigationController?.popViewController(animated: true)
                        }))
                        self?.present(successAlert, animated: true, completion: nil)
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        guard let game = self.game else { return }
        
        let alert = UIAlertController(
            title: "Add Favorite",
            message: "Do you want to add this game to your favorites?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.viewModel.addToFavorite(game: game)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    private func setup() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: "MainDetailTableCell", bundle: nil),
            forCellReuseIdentifier: MainDetailTableCell.identifier
        )
        tableView.register(
            UINib(
                nibName: "GenreDetailTableCell", bundle: nil),
            forCellReuseIdentifier: GenreDetailTableCell.identifier
        )
        tableView.register(
            UINib(nibName: "ScreenshotTableCell", bundle: nil),
            forCellReuseIdentifier: ScreenshotTableCell.identifier)
        tableView.separatorStyle = .none
        
    }
    
    private func setupBarButtonItem() {
        updateFavoriteButton(isFavorite: isFromFavorites)
    }
    
}

// MARK: - TableView
extension GameDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = GameDetailSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sectionType {
        case .mainDetail:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MainDetailTableCell.identifier,
                for: indexPath) as? MainDetailTableCell,
                  let game = game else { return UITableViewCell() }
            
            cell.setupData(game: game)
            return cell
            
        case .genres:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: GenreDetailTableCell.identifier,
                for: indexPath) as? GenreDetailTableCell,
                  let genre = game?.genres else { return UITableViewCell() }
            cell.setupData(name: genre[indexPath.row].name, picture: genre[indexPath.row].imageBackground)
            return cell
            
        case .screenshots:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ScreenshotTableCell.identifier,
                for: indexPath) as? ScreenshotTableCell,
                  let screenshots = game?.shortScreenshots else { return UITableViewCell() }
            cell.setupScreenshot(url: screenshots[indexPath.row].image)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = GameDetailSection(rawValue: section), let game = game else { return 1 }
        switch sectionType {
        case .mainDetail:
            return 1
        case .genres:
            return game.genres.count
        case .screenshots:
            return game.shortScreenshots.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = GameDetailSection(rawValue: section) else { return nil }
        
        switch sectionType {
        case .mainDetail:
            return nil
        case .genres:
            guard let _ = game?.genres else {
                return nil
            }
            return makeHeaderView(name: "Genres")
        case .screenshots:
            guard let _ = game?.shortScreenshots else {
                return nil
            }
            return makeHeaderView(name: "Screenshots")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = GameDetailSection(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .mainDetail:
            return 0
        case .genres, .screenshots:
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return game != nil ? GameDetailSection.numberOfSections() : 0
    }
    
}

// MARK: Utils
extension GameDetailViewController {
    private func makeHeaderView(name: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Background")
        let headerLabel = UILabel()
        headerLabel.text = name
        headerLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headerLabel.textColor = UIColor(named: "Headline")
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}
