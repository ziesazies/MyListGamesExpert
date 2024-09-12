//
//  FetchGameDetailUseCaseImpl.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class FetchGameDetailUseCaseImpl: FetchGameDetailUseCase {
    
    private let repository: GameRepository
    
    init(repository: GameRepository) {
        self.repository = repository
    }
    
    func fetchGameDetail(id: Int) -> Observable<Game> {
        return repository.fetchGameDetail(id: id)
    }
}
