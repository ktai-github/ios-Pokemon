//
//  JsonTests.swift
//  PokemonTests
//
//  Created by KevinT on 2018-03-22.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import XCTest
@testable import Pokemon

class JsonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      
      
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func test_jsonObjectFromData_GivenEmptyData_ShouldThrowAnError() {
    let pokémonRequest = PokemonAPIRequest(networker: MockNetworker())
    let data = Data()
    XCTAssertThrowsError(try pokémonRequest.jsonObject(fromData: data))
  }
  
  func test_jsonObjectFromData_GivenInvalidJsonData_ShouldThrowAnError() {
    let networker = MockNetworker()
    let pokémonRequest = PokemonAPIRequest(networker: networker)
    
    let invalidJSON = ""
    let data = invalidJSON.data(using: .utf8)!
    XCTAssertThrowsError(try pokémonRequest.jsonObject(fromData: data))
  }
  
  func test_jsonObjectFromData_GivenJSONObjectData_ShouldReturnJSONObject() {
    let networker = MockNetworker()
    let pokémonRequest = PokemonAPIRequest(networker: networker)

    let validJSON = "{\"\":\"\"}"
    let data = validJSON.data(using: .utf8)!
    guard let result = try! pokémonRequest.jsonObject(fromData: data) as? [String: String] else {
      XCTFail("Invalid JSON returned")
      return
    }
    XCTAssertEqual(result, ["":""])
    
  }
  
  func test_viewControllerIsSetAsTableViewDataSource() {
    
    let bundleMain = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundleMain)
    let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

    UIApplication.shared.keyWindow?.rootViewController = viewController

    // Test and Load the View at the Same Time!
    XCTAssertNotNil(viewController.view)

//    let viewController = UIApplication.shared.windows[0].rootViewController as! ViewController
    
    let resutingViewController = viewController.tableView.dataSource as? UIViewController
  
    XCTAssertEqual(resutingViewController, viewController)
  }
  
  func test_tableViewPopulatedFromNetworkRequest() {
    
//    var pokemons: [Pokemon] = []
    let networkManager: NetworkerType = MockNetworker()

    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
    let viewController = UIApplication.shared.windows[0].rootViewController as! ViewController
    XCTAssertNotNil(viewController.view)
    
    pokemonAPI.getAllPokemons { (pokemons, error) in
      if let error = error {
        print("Error: \(error)")
      }
      
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        return
      }
      
      viewController.pokemons = pokemons
      viewController.tableView.reloadData()
      
      let tableRows = viewController.tableView.numberOfRows(inSection: 0)
      XCTAssertTrue(tableRows > 0)

    }
    
  }
  
  func test_buildURLReturnsCorrectURL() {
//    var pokemons: [Pokemon] = []
    let networkManager: NetworkerType = NetworkManager()
    
    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
    let pokemonURL = pokemonAPI.buildURL(endpoint: "pokemon")
    XCTAssertEqual(pokemonURL?.absoluteString, "https://pokeapi.co/api/v2/pokemon")
  }
  
  func test_pokemonsFromResultsNameValid() {
    let networker = NetworkManager()
//    let pokémonRequest = PokemonAPIRequest(networker: networker)
//
//    let validJSON = "{\"\":\"\"}"
//    let data = validJSON.data(using: .utf8)!
    let pokemonAPI = PokemonAPIRequest(networker: networker)
//    guard let result = try! pokémonRequest.jsonObject(fromData: data) as? [String: String] else {
    pokemonAPI.getAllPokemons { (pokemons, error) in
      if let error = error {
        print("Error: \(error)")
      }
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        return
      }
      
//      XCTAssertEqual(pokemons[0].name, "ba")
//      XCTAssertEqual(pokemons[0].url, "https://pokeapi.co/api/v2/pokemon/1/")

    }
  }
    
    func test_pokemonsFromResultsUrlValid() {
      let networker = NetworkManager()
      //    let pokémonRequest = PokemonAPIRequest(networker: networker)
      //
      //    let validJSON = "{\"\":\"\"}"
      //    let data = validJSON.data(using: .utf8)!
      let pokemonAPI = PokemonAPIRequest(networker: networker)
      //    guard let result = try! pokémonRequest.jsonObject(fromData: data) as? [String: String] else {
      pokemonAPI.getAllPokemons { (pokemons, error) in
        if let error = error {
          print("Error: \(error)")
        }
        guard let pokemons = pokemons else {
          print("Error getting pokemon")
          return
        }

        XCTAssertEqual(pokemons[0].url, "https://pokeapi.co/api/v2/pokemon/1/")
        
      }
  }
}
//    guard let pokemonArray = pokémonRequest.pokemons(fromJSON: data) as [String: String] else {
//      XCTFail("Invalid JSON returned")
//      return
//    }
    


//  func test_InvalidJsonDataFromGetAllPokemon() {
//
//    var pokemons: [Pokemon] = []
//    var networkManager: NetworkerType = InvalidJsonMockNetworker()
//
//    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
//    let viewController = UIApplication.shared.windows[0].rootViewController as! ViewController
//    XCTAssertNotNil(viewController.view)
//
//    pokemonAPI.getAllPokemons { (pokemons, error) in
//      if let error = error {
//        print("Error: \(error)")
//      }
//
//      guard let pokemons = pokemons else {
//        print("Error getting pokemon")
//        return
//      }
//
//      viewController.pokemons = pokemons
//      xct
//
//    }
//
//  }
