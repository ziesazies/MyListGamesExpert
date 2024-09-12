//
//  GameProvider.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 30/08/24.
//

import Foundation
import CoreData
import RxSwift

class GameProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGames")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func fetchFavoriteGames() -> Single<[Game]> {
        return Single.create { single in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var games: [Game] = []
                    for result in results {
                        let game = Game(
                            id: result.value(forKey: "id") as? Int ?? 0,
                            name: result.value(forKey: "name") as? String ?? "",
                            released: result.value(forKey: "released") as? String ?? "",
                            backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                            rating: result.value(forKey: "rating") as? Double ?? 0.0,
                            genres: [],
                            shortScreenshots: [],
                            descriptionRaw: ""
                        )
                        games.append(game)
                    }
                    single(.success(games))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteGame(_ id: Int) -> Completable {
        return Completable.create { completable in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try taskContext.execute(batchDeleteRequest)
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getGameById(_ id: Int) -> Maybe<Game> {
        return Maybe.create { maybe in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                
                do {
                    if let result = try taskContext.fetch(fetchRequest).first {
                        let game = Game(
                            id: result.value(forKey: "id") as? Int ?? 0,
                            name: result.value(forKey: "name") as? String ?? "",
                            released: result.value(forKey: "released") as? String ?? "",
                            backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                            rating: result.value(forKey: "rating") as? Double ?? 0.0,
                            genres: [],
                            shortScreenshots: [],
                            descriptionRaw: ""
                        )
                        maybe(.success(game))
                    } else {
                        maybe(.completed)
                    }
                } catch {
                    maybe(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func saveGameToFavorites(game: Game) -> Completable {
        return Completable.create { completable in
            let taskContext = self.newTaskContext()
            taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: taskContext) {
                    let gameObject = NSManagedObject(entity: entity, insertInto: taskContext)
                    gameObject.setValue(game.id, forKey: "id")
                    gameObject.setValue(game.name, forKey: "name")
                    gameObject.setValue(game.released, forKey: "released")
                    gameObject.setValue(game.backgroundImage, forKey: "backgroundImage")
                    gameObject.setValue(game.rating, forKey: "rating")
                    do {
                        try taskContext.save()
                        completable(.completed)
                    } catch {
                        completable(.error(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
