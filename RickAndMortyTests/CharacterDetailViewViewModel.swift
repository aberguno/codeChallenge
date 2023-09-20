//
//  CharacterDetailViewViewModel.swift
//  RickAndMortyTests
//
//  Created by Ariel Berguño on 20/09/2023.
//

import Combine
@testable import RickAndMorty
import XCTest

class CharacterDetailViewViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var viewModel: CharacterDetailViewViewModel!
    fileprivate var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkClient = MockNetworkClient()
        
        // Create a mock character to inject into the view model
        let mockCharacter = CharacterModel(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: LocationModel(id: nil, name: "Earth", type: nil, dimension: nil, residents: nil, url: "", created: nil),
            location: LocationModel(id: nil, name: "Earth", type: nil, dimension: nil, residents: nil, url: "validUrl", created: nil),
            image: "http://example.com/image.png",
            episode: [],
            url: "",
            created: "")
        
        viewModel = CharacterDetailViewViewModel(character: mockCharacter, networkClient: mockNetworkClient)
    }
    
    @MainActor func testRequestLocationWithValidURL() {
        let expectation = expectation(description: "Fetch location detail with valid URL")
        
        viewModel.$locationDetailType
            .dropFirst()
            .sink { locationDetail in
                XCTAssertNotNil(locationDetail)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.requestLocation()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// Create a mock network client for testing purposes
private class MockNetworkClient: NetworkClientProtocol {
    func get<Response>(_ endpoint: RickAndMorty.APIClient.Endpoint) async throws -> Response where Response: Decodable {
        return LocationModel(id: nil, name: "unknown", type: nil, dimension: nil, residents: nil, url: "", created: nil) as! Response
    }
}
