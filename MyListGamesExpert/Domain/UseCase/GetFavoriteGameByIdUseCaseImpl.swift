//
//  FetchFavoriteGameByIdUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class GetFavoriteGameByIdUseCaseImpl: GetFavoriteGameByIdUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func fetchFavoriteGameById(id: Int) -> Maybe<Game> {
        return repository.getFavoriteGameById(id: id)
    }
}
