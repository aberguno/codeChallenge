//
//  CharactersListTableViewViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Ariel Berguño on 20/09/2023.
//

import XCTest

import Combine
@testable import RickAndMorty

final class CharactersListTableViewViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    var viewModel: CharactersListTableViewViewModel!
    fileprivate var mockNetworkClient: MockNetworkClient!

    override func setUp() {
        super.setUp()

        // Setup a mock network client and inject it into the view model
        mockNetworkClient = MockNetworkClient()
        viewModel = CharactersListTableViewViewModel(networkClient: mockNetworkClient)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkClient = nil
        super.tearDown()
    }

    @MainActor func testRequestNextCharacters() {
        let expectation = XCTestExpectation(description: "Characters fetched")

        // Observe changes to properties and fulfill expectation if properties are set correctly
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertTrue(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.requestNextCharacters()

        wait(for: [expectation], timeout: 1.0)
    }
}

// Create a mock network client for testing purposes
private class MockNetworkClient: NetworkClientProtocol {
    func get<Response>(_ endpoint: RickAndMorty.APIClient.Endpoint) async throws -> Response where Response: Decodable {
        let character = CharacterModel(id: 1,
                                       name: "Rick",
                                       status: "Alive",
                                       species: "Human",
                                       type: "",
                                       gender: "Male",
                                       origin: LocationModel(id: nil, name: "Earth", type: nil, dimension: nil, residents: nil, url: "https://rickandmortyapi.com/location/1", created: nil),
                                       location: LocationModel(id: nil, name: "Mars", type: nil, dimension: nil, residents: nil, url: "https://rickandmortyapi.com/location/2", created: nil),
                                       image: "https://rickandmortyapi.com/character/1.jpg",
                                       episode: ["https://rickandmortyapi.com/episode/1"],
                                       url: "https://rickandmortyapi.com/character/1",
                                       created: "2023-09-16")

        return CharacterResponseModel(info: InfoModel(count: 0, pages: 0, next: nil, prev: nil), results: [character]) as! Response
    }
}
