//
//  AppDIContainer.swift
//  MyListGamesExpert
//
//  Created by Alief Ahmad Azies on 11/09/24.
//

import Foundation
import Swinject

class AppDIContainer {
    static let shared = AppDIContainer()
    
    let container: Container
    
    // swiftlint:disable function_body_length
    private init() {
        container = Container()
        
        // Register services
        container.register(NetworkService.self) { _ in NetworkService() }
        container.register(GameProvider.self) { _ in GameProvider() }
        
        // Register repositories
        container.register(GameRepository.self) { resolver in
            let networkService = resolver.resolve(NetworkService.self)!
            let gameProvider = resolver.resolve(GameProvider.self)!
            return GameRepositoryImpl(networkService: networkService, gameProvider: gameProvider)
        }
        
        // Register use case
        container.register(FetchGamesUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return FetchGamesUseCaseImpl(repository: repository)
        }
        
        container.register(FetchGameDetailUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return FetchGameDetailUseCaseImpl(repository: repository)
        }
        
        container.register(SaveFavoriteGameUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return SaveFavoriteGameUseCaseImpl(repository: repository)
        }
        
        container.register(GetFavoriteGamesUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return GetFavoriteGamesUseCaseImpl(repository: repository)
        }
        
        container.register(GetFavoriteGameByIdUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return GetFavoriteGameByIdUseCaseImpl(repository: repository)
        }
        
        container.register(DeleteFavoriteGameUseCase.self) { resolver in
            let repository = resolver.resolve(GameRepository.self)!
            return DeleteFavoriteGameUseCaseImpl(repository: repository)
        }
        
        container.register(HomeViewModel.self) { resolver in
            let useCase = resolver.resolve(FetchGamesUseCase.self)!
            return HomeViewModel(fetchGamesUseCase: useCase)
        }
        
        container.register(GameDetailViewModel.self) { resolver in
            let fetchGameDetailUseCase = resolver.resolve(FetchGameDetailUseCase.self)!
            let saveFavoriteGameUseCase = resolver.resolve(SaveFavoriteGameUseCase.self)!
            let getFavoriteGameByIdUseCase = resolver.resolve(GetFavoriteGameByIdUseCase.self)!
            let deleteGameByIdUseCase = resolver.resolve(DeleteFavoriteGameUseCase.self)!
            
            return GameDetailViewModel(
                fetchGameDetailUseCase: fetchGameDetailUseCase,
                getFavoriteGameByIdUseCase: getFavoriteGameByIdUseCase,
                saveFavoriteGameUseCase: saveFavoriteGameUseCase,
                deleteGameByIdUseCase: deleteGameByIdUseCase
            )
        }
        
        container.register(FavoriteListViewModel.self) { resolver in
            let getFavoriteGamesUseCase = resolver.resolve(GetFavoriteGamesUseCase.self)!
            return FavoriteListViewModel(getFavoriteGamesUseCase: getFavoriteGamesUseCase)
        }
    }
}
