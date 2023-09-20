//
//  CharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Combine
import UIKit

final class CharacterDetailViewViewModel {
    @Published private(set) var characterFavorited: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var locationDetailType: String = ""
    @Published private(set) var locationDetailDimension: String = ""
    
    private let character: CharacterModel
    private(set) var locationDetail: LocationModel? {
        didSet {
            locationDetailType = locationDetail?.type?.capitalized ?? "Unknown"
            locationDetailDimension = locationDetail?.dimension?.capitalized ?? "Unknown"
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let networkClient: NetworkClientProtocol
    
    // MARK: - Init

    init(character: CharacterModel, networkClient: NetworkClientProtocol = APIClient.Network.shared) {
        self.character = character
        self.networkClient = networkClient
        
        createBindingViewFavorites()
    }
    
    public var title: String {
        characterName.uppercased()
    }
    
    public var characterId: Int {
        character.id
    }
  
    public var characterName: String {
        character.name
    }
    
    public var characterImageUrl: URL? {
        return URL(string: character.image)
    }
    
    public var characterOriginName: String {
        return character.origin.name.uppercased()
    }
        
    public var imageForOrigin: UIImage? {
        return Utils.imageForOrigin(characterOriginIsUnknown: character.origin.name == "unknown")
    }
    
    public var characterLocationName: String {
        return character.location.name.capitalized
    }
    
    public var isCharacterLocationUnknown: Bool {
        return character.location.name == "unknown"
    }
    
    public var characterStatusAndSpecieText: NSMutableAttributedString {
        return Utils.formatStatusSpecieLabel(status: character.status, species: character.species)
    }
    
    @MainActor
    func requestLocation() {
        guard character.location.name != "unknown" else { return }
        
        errorMessage = nil
        isLoading = true

        Task {
            do {
                locationDetail = try await networkClient.get(.locationByUrlString(character.location.url))
            } catch let error as APIClient.Error {
                errorMessage = error.errorDescription
            }
            
            isLoading = false
        }
    }
}

extension CharacterDetailViewViewModel {
    func createBindingViewFavorites() {
        Favorites.shared.$favorites.sink { [weak self] favorites in
            guard let weakSelf = self else { return }
            weakSelf.characterFavorited = favorites.contains(weakSelf.characterId)
        }.store(in: &cancellables)
    }
}
