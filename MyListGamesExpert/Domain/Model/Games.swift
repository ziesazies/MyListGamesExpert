//
//  Games.swift
//  MyListGames
//
//  Created by Alief Ahmad Azies on 26/08/24.
//

import Foundation

struct Games: Codable {
    let status: String
    let games: [Game]
    
    enum CodingKeys: String, CodingKey {
        case status
        case games = "results"
    }
}

// MARK: - Game
struct Game: Codable {
    let id: Int
    let name, released: String
    let backgroundImage: String
    let rating: Double
    let genres: [Genre]
    let shortScreenshots: [ShortScreenshot]
    let descriptionRaw: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case genres
        case shortScreenshots = "short_screenshots"
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name, slug: String
    let gamesCount: Int
    let imageBackground: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable {
    let id: Int
    let image: String
}
