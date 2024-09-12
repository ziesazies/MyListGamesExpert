//
//  FetchGameDetailUseCase.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 10/09/24.
//

import Foundation
import RxSwift

protocol FetchGameDetailUseCase {
    func fetchGameDetail(id: Int) -> Observable<Game>
}
