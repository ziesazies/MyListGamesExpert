//
//  FetchFavoriteGameByIdUseCase.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

protocol GetFavoriteGameByIdUseCase {
    func fetchFavoriteGameById(id: Int) -> Maybe<Game>
}
