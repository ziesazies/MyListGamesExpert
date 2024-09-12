//
//  SaveFavoriteGameUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class SaveFavoriteGameUseCaseImpl: SaveFavoriteGameUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func saveGameToFavorites(game: Game) -> Completable {
        return repository.saveFavoriteGame(game: game)
    }
    
}
