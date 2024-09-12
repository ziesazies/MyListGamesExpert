//
//  HomeViewModel.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import RxSwift

class HomeViewModel {
    // Dependecies
    private let fetchGamesUseCase: FetchGamesUseCase
    
    // Outputs
    let games: PublishSubject<[Game]> = PublishSubject()
    let isLoading: PublishSubject<Bool> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init(fetchGamesUseCase: FetchGamesUseCase) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    func loadGames() {
        isLoading.onNext(true)
        
        fetchGamesUseCase.fetchGames()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] games in
                self?.games.onNext(games)
                self?.isLoading.onNext(false)
            }, onError: { [weak self] error in
                self?.errorMessage.onNext(error.localizedDescription)
                self?.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
