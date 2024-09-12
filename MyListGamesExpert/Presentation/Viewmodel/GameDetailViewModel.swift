//
//  GameDetailViewModel.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class GameDetailViewModel {
    private let fetchGameDetailUseCase: FetchGameDetailUseCase
    private let getFavoriteGameByIdUseCase: GetFavoriteGameByIdUseCase
    private let saveFavoriteGameUseCase: SaveFavoriteGameUseCase
    private let deleteGameByIdUseCase: DeleteFavoriteGameUseCase
    
    private let disposeBag = DisposeBag()
    
    let gameDetail: BehaviorSubject<Game?> = BehaviorSubject(value: nil)
    let isFavorite: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let errorMessage: PublishSubject<String> = PublishSubject()
    
    init(
        fetchGameDetailUseCase: FetchGameDetailUseCase,
        getFavoriteGameByIdUseCase: GetFavoriteGameByIdUseCase,
        saveFavoriteGameUseCase: SaveFavoriteGameUseCase,
        deleteGameByIdUseCase: DeleteFavoriteGameUseCase
    ) {
        self.fetchGameDetailUseCase = fetchGameDetailUseCase
        self.getFavoriteGameByIdUseCase = getFavoriteGameByIdUseCase
        self.saveFavoriteGameUseCase = saveFavoriteGameUseCase
        self.deleteGameByIdUseCase = deleteGameByIdUseCase
    }
    
    func fetchGameDetail(id: Int) {
        fetchGameDetailUseCase.fetchGameDetail(id: id)
            .subscribe(onNext: { [weak self] game in
                self?.gameDetail.onNext(game)
            }, onError: {[weak self] _ in
                self?.errorMessage.onNext("Failed to fetch game details")
            })
            .disposed(by: disposeBag)
    }
    
    func checkIfFavorite(id: Int) {
        getFavoriteGameByIdUseCase.fetchFavoriteGameById(id: id)
            .subscribe(onSuccess: { [weak self] _ in
                self?.isFavorite.onNext(true)
            }, onError: { [weak self] _ in
                self?.isFavorite.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func addToFavorite(game: Game) {
        saveFavoriteGameUseCase.saveGameToFavorites(game: game)
            .subscribe(onCompleted: { [weak self] in
                self?.isFavorite.onNext(true)
            }, onError: { [weak self] _ in
                self?.errorMessage.onNext("Failed to add favorites")
            })
            .disposed(by: disposeBag)
    }
    
    func removeGameFromFavorite(id: Int) {
        deleteGameByIdUseCase.deleteFavoriteGame(id: id)
            .subscribe(onCompleted: { [weak self] in
                self?.isFavorite.onNext(false)
                
            }, onError: { [weak self] _ in
                self?.errorMessage.onNext("Failed to remove from favorites")
            })
            .disposed(by: disposeBag)
    }
    
}
