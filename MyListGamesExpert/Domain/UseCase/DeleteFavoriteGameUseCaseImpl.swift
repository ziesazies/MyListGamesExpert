//
//  DeleteFavoriteGameUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class DeleteFavoriteGameUseCaseImpl: DeleteFavoriteGameUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func deleteFavoriteGame(id: Int) -> Completable {
        return repository.deleteGameById(id: id)
    }
}
