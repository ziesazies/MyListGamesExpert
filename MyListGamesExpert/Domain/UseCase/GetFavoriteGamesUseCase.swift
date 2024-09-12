//
//  GetFavoriteGamesUseCase.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 10/09/24.
//

import Foundation
import RxSwift

protocol GetFavoriteGamesUseCase {
    func getFavoriteGames() -> Observable<[Game]>
}
