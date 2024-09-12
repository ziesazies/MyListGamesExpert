//
//  ViewController.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 26/08/24.
//

import UIKit
import SDWebImage
import RxSwift

class HomeViewController: UIViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Properties
    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private var games: [Game] = []
    
    func setupViewModel(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeViewModel = AppDIContainer.shared.container.resolve(HomeViewModel.self)!
        setupViewModel(viewModel: homeViewModel)
        setup()
    }
    
    private func setup() {
        title = "My List Games"
        view.backgroundColor = UIColor(named: "Background")
        
        setupTableView()
        bindViewModel()
        
        setupBarButtonItem()
        viewModel.loadGames()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.register(
            UINib(
                nibName: "GameTableCell",
                bundle: nil),
            forCellReuseIdentifier: GameTableCell.identifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func bindViewModel() {
        viewModel.games
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] games in
                self?.games = games
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupBarButtonItem() {
        // Profile Button
        let profile = UIBarButtonItem(
            title: "",
            image: UIImage(
                systemName: "person.fill")?.withTintColor(
                    UIColor(
                        named: "Headline") ?? .systemBlue,
                    renderingMode: .alwaysOriginal),
            target: self,
            action: #selector(profileButtonTapped(_:)))
        // Favorite List Button
        let favoriteList = UIBarButtonItem(
            title: "",
            image: UIImage(
                systemName: "heart.fill")?.withTintColor(
                    UIColor(named: "Headline") ?? .systemYellow, renderingMode: .alwaysOriginal),
            target: self,
            action: #selector(favoriteListButtonTapped(_:))
        )
        
        self.navigationItem.rightBarButtonItems = [profile, favoriteList]
    }
    
    // MARK: - Actions
    @objc func profileButtonTapped(_ sender: Any) {
        let aboutVC = AboutAuthorViewController()
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    @objc func favoriteListButtonTapped(_ sender: Any) {
        let favoriteViewModel = AppDIContainer.shared.container.resolve(FavoriteListViewModel.self)!
        let favoriteVC = FavoriteListViewController(viewModel: favoriteViewModel)
        self.navigationController?.pushViewController(favoriteVC, animated: true)
    }
}

// MARK: - Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableCell.identifier,
            for: indexPath) as? GameTableCell else {
            return UITableViewCell()
        }
        cell.configCell(game: games[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewModel = AppDIContainer.shared.container.resolve(GameDetailViewModel.self)!
        let detailVC = GameDetailViewController(viewModel: gameDetailViewModel)
        detailVC.id = games[indexPath.row].id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
