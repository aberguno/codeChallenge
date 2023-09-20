//
//  Character.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 16/09/2023.
//

import Foundation

struct CharacterResponseModel: Codable {
    let info: InfoModel
    let results: [CharacterModel]
}

struct InfoModel: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterModel: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationModel
    let location: LocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
