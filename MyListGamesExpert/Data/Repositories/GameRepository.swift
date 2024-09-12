//
//  GameRepository.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 10/09/24.
//

import Foundation
import RxSwift

protocol GameRepository {
    func fetchGames() -> Observable<[Game]>
    func fetchGameDetail(id: Int) -> Observable<Game>
    func saveFavoriteGame(game: Game) -> Completable
    func getFavoriteGames() -> Observable<[Game]>
    func getFavoriteGameById(id: Int) -> Maybe<Game>
    func deleteGameById(id: Int) -> Completable
}
