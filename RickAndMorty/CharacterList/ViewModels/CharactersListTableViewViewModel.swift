//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 16/09/2023.
//

import Combine
import Foundation

final class CharactersListTableViewViewModel {
    @Published var cellViewModels: [CharacterTableViewCellViewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    public private(set) var characters: [CharacterModel] = []

    private var currentPage = 0
    private var lastPageReached = false
    private var cancellables = Set<AnyCancellable>()

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = APIClient.Network.shared) {
        self.networkClient = networkClient
    }

    @MainActor
    func requestNextCharacters() {
        guard !lastPageReached else { return }

        errorMessage = nil
        isLoading = true

        let nextPage = currentPage + 1

        Task {
            do {
                let resultCharacters: CharacterResponseModel = try await networkClient.get(.character(page: nextPage))
                createCellViewModels(characters: resultCharacters.results)
                characters.append(contentsOf: resultCharacters.results)
                currentPage += 1
                lastPageReached = resultCharacters.info.next == nil
            } catch let error as APIClient.Error {
                errorMessage = error.errorDescription
            }

            isLoading = false
        }
    }
}

private extension CharactersListTableViewViewModel {
    func createCellViewModels(characters: [CharacterModel]) {
        for character in characters {
            let viewModel = CharacterTableViewCellViewModel(
                characterId: character.id,
                characterName: character.name,
                characterStatus: character.status,
                characterSpecies: character.species,
                characterImageUrl: URL(string: character.image)
            )
            if !cellViewModels.contains(viewModel) {
                cellViewModels.append(viewModel)
            }
        }
    }
}
