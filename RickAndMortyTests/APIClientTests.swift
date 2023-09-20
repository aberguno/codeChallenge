//
//  APIClientTests.swift
//  RickAndMortyTests
//
//  Created by Ariel Berguño on 20/09/2023.
//

@testable import RickAndMorty
import XCTest

final class APIClientTests: XCTestCase {
    var apiClientNetwork: APIClient.Network!

    override func setUpWithError() throws {
        super.setUp()
        apiClientNetwork = APIClient.Network.shared
    }

    override func tearDownWithError() throws {
        apiClientNetwork = nil
        super.tearDown()
    }

    func testFetchingCharacterEndpointSuccessfully() async throws {
        let endpoint = APIClient.Endpoint.character(page: 1)

        do {
            let response: CharacterResponseModel = try await apiClientNetwork.get(endpoint)
            XCTAssertNotNil(response, "Response should not be nil")
        } catch {
            XCTFail("Fetching endpoint failed with error: \(error)")
        }
    }

    func testInvalidURL() async throws {
        let endpoint = APIClient.Endpoint.character(page: -1)

        do {
            let response: CharacterResponseModel = try await apiClientNetwork.get(endpoint)
            XCTAssertNotNil(response, "Response should not be nil")
        } catch let error as APIClient.Error {
            XCTAssertEqual(error.errorDescription, "Internal Error: Invalid URL", "Error should be 'Internal Error: Invalid URL'")
        } catch {
            XCTFail("Fetching endpoint failed with unexpected error: \(error)")
        }
    }

    func testEncodingDecodingFunctions() {
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

        do {
            let encodedData = try apiClientNetwork.encodeJSONData(data: character)
            XCTAssertNotNil(encodedData, "Encoded data should not be nil")

            let decodedCharacter: CharacterModel = try apiClientNetwork.decodeJSONData(data: encodedData)
            XCTAssertEqual(decodedCharacter.name, character.name, "Decoded character name should match the original character name")

        } catch {
            XCTFail("Error in encoding/decoding: \(error)")
        }
    }
}
