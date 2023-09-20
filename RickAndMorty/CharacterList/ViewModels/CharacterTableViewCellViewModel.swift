//
//  CharacterTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 18/09/2023.
//

import Combine
import Foundation
import UIKit

final class CharacterTableViewCellViewModel: Hashable, Equatable {
    public let characterId: Int
    public let characterName: String
    public let characterImageUrl: URL?

    private let characterStatus: String
    private let characterSpecies: String
    
    public private(set) var characterFavorited: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    init(characterId: Int, characterName: String, characterStatus: String, characterSpecies: String, characterImageUrl: URL?) {
        self.characterId = characterId
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterSpecies = characterSpecies
        self.characterImageUrl = characterImageUrl
        
        self.createBindingViewFavorites()
    }

    public var characterStatusAndSpecieText: NSMutableAttributedString {
        return Utils.formatStatusSpecieLabel(status: characterStatus, species: characterSpecies)
    }

    // MARK: - Hashable

    static func == (lhs: CharacterTableViewCellViewModel, rhs: CharacterTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}

private extension CharacterTableViewCellViewModel {
    func createBindingViewFavorites() {
        Favorites.shared.$favorites.sink { [weak self] favorites in
            guard let weakSelf = self else { return }
            weakSelf.characterFavorited = favorites.contains(weakSelf.characterId)
        }.store(in: &cancellables)
    }
}
