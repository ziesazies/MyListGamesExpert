//
//  NetworkService.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 26/08/24.
//

import Foundation
import RxSwift

class NetworkService {
    
    func getGames() -> Single<[Game]> {
        return Single.create { single in
            guard let url = URL(string: "https://rawg-mirror.vercel.app/api/games") else {
                single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    single(.failure(
                        NSError(
                            domain: "",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }
                
                guard let data = data else {
                    single(.failure(
                        NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Games.self, from: data)
                    single(.success(result.games))
                } catch {
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func getGameDetail(id: Int) -> Single<Game> {
        return Single.create { single in
            guard let url = URL(string: "https://rawg-mirror.vercel.app/api/games/\(id)") else {
                single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return Disposables.create()
            }
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    single(.failure(
                        NSError(domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid response"]
                               )
                    ))
                    return
                }
                
                guard let data = data else {
                    single(.failure(
                        NSError(
                            domain: "",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No data received"]
                        )
                    ))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Game.self, from: data)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
