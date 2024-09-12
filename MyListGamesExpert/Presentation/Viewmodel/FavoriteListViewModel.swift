//
//  FavoriteListViewModel.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 12/09/24.
//

import Foundation
import RxSwift

class FavoriteListViewModel {
    private let getFavoriteGamesUseCase: GetFavoriteGamesUseCase
    private let disposeBag = DisposeBag()
    
    // Outputs
    let favoriteGame: BehaviorSubject<[Game]> = BehaviorSubject(value: [])
    let errorMessage: PublishSubject<String> = PublishSubject()
    
    init(getFavoriteGamesUseCase: GetFavoriteGamesUseCase) {
        self.getFavoriteGamesUseCase = getFavoriteGamesUseCase
    }
    
    func getFavoriteGames() {
        getFavoriteGamesUseCase.getFavoriteGames()
            .subscribe(onNext: { [weak self] games in
                if games.isEmpty {
                    self?.favoriteGame.onNext([])
                    self?.errorMessage.onNext("Your Favorite list is empty")
                } else {
                    self?.favoriteGame.onNext(games)
                }
            }, onError: { [weak self] _ in
                self?.errorMessage.onNext("Failed to load favorite games")
            })
            .disposed(by: disposeBag)
    }
}
