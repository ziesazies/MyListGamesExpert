//
//  FetchGamesUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class FetchGamesUseCaseImpl: FetchGamesUseCase {
    
    let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func fetchGames() -> Observable<[Game]> {
        repository.fetchGames()
    }
}
