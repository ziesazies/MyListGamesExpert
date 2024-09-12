//
//  GameRepositoryImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 10/09/24.
//

import Foundation
import RxSwift

class GameRepositoryImpl: GameRepository {
    
    private let networkService: NetworkService
    private let gameProvider: GameProvider
    
    init(networkService: NetworkService, gameProvider: GameProvider) {
        self.networkService = networkService
        self.gameProvider = gameProvider
    }
    
    func fetchGames() -> Observable<[Game]> {
        networkService.getGames().asObservable()
    }
    
    func fetchGameDetail(id: Int) -> Observable<Game> {
        networkService.getGameDetail(id: id).asObservable()
    }
    
    func saveFavoriteGame(game: Game) -> Completable {
        gameProvider.saveGameToFavorites(game: game)
    }
    
    func getFavoriteGames() -> Observable<[Game]> {
        gameProvider.fetchFavoriteGames().asObservable()
    }
    
    func getFavoriteGameById(id: Int) -> Maybe<Game> {
        gameProvider.getGameById(id)
    }
    
    func deleteGameById(id: Int) -> Completable {
        gameProvider.deleteGame(id)
    }
}
