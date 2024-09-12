//
//  GetFavoriteGamesUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class GetFavoriteGamesUseCaseImpl: GetFavoriteGamesUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func getFavoriteGames() -> Observable<[Game]> {
        return repository.getFavoriteGames()
    }
    
}
