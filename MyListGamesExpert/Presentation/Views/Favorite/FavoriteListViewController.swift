//
//  FavoriteListViewController.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 30/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteListViewController: UIViewController {
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    private let viewModel: FavoriteListViewModel
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UINib(
                nibName: "GameTableCell",
                bundle: nil),
            forCellReuseIdentifier: GameTableCell.identifier)
        return tableView
    }()
    
    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Games"
        setupView()
        bindViewModel()
        viewModel.getFavoriteGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoriteGames()
    }
    
    // MARK: - Setup Views
    private func setupView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.favoriteGame
            .observe(on: MainScheduler.instance)
            .skip(1)
            .bind(to: tableView.rx.items(
                cellIdentifier: GameTableCell.identifier,
                cellType: GameTableCell.self)
            ) { _, game, cell in
                cell.configCell(game: game)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                self?.showEmptyFavoritesAlert(message: message)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Game.self)
            .subscribe(onNext: { [weak self] game in
                let gameDetailViewModel = AppDIContainer.shared.container.resolve(GameDetailViewModel.self)!
                let detailVC = GameDetailViewController(viewModel: gameDetailViewModel)
                detailVC.id = game.id
                detailVC.isFromFavorites = true
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func showEmptyFavoritesAlert(message: String) {
        let alert = UIAlertController(title: "No Favorites", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
