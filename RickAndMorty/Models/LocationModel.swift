//
//  Location.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 16/09/2023.
//

import Foundation

//extension API.Types.Response {
    struct LocationModel: Codable {
        let id: Int?
        let name: String
        let type: String?
        let dimension: String?
        let residents: [String]?
        let url: String
        let created: String?
    }
//}
