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
  
  //needed for tests
  var bundleMain: Bundle!
  var mockPokemonRequest: PokemonAPIRequest!
  var pokemonRequest: PokemonAPIRequest!
  
    override func setUp() {
      super.setUp()
      
      bundleMain = Bundle.main
      
      //mock networker with mock API request
      let mockNetworker = MockNetworker() //NetworkType
      mockPokemonRequest = PokemonAPIRequest(networker: mockNetworker)
      
      //real networker with real API request
      let networkManager = NetworkManager() //NetworkType
      pokemonRequest = PokemonAPIRequest(networker: networkManager)

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
//  test with empty data
  func test_jsonObjectFromData_GivenEmptyData_ShouldThrowAnError() {
    let data = Data()
    XCTAssertThrowsError(try mockPokemonRequest.jsonObject(fromData: data))
  }
  
//  test with invalid data
  func test_jsonObjectFromData_GivenInvalidJsonData_ShouldThrowAnError() {
    let invalidJSON = ""
    let data = invalidJSON.data(using: .utf8)!
    XCTAssertThrowsError(try mockPokemonRequest.jsonObject(fromData: data))
  }
  
//  test with valid data
  func test_jsonObjectFromData_GivenJSONObjectData_ShouldReturnJSONObject() {
    let validJSON = "{\"\":\"\"}"
    let data = validJSON.data(using: .utf8)!
    guard let result = try! mockPokemonRequest.jsonObject(fromData: data) as? [String: String] else {
      XCTFail("Invalid JSON returned")
      return
    }
    
    XCTAssertEqual(result, ["":""])
    
  }
  
//  Test the view controller is set as the table view's data source.
  func test_viewControllerIsSetAsTableViewDataSource() {
    let storyboard = UIStoryboard(name: "Main", bundle: bundleMain)
    let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

    UIApplication.shared.keyWindow?.rootViewController = viewController

    // Test and Load the View at the Same Time!
    XCTAssertNotNil(viewController.view)

//    let viewController = UIApplication.shared.windows[0].rootViewController as! ViewController
    
    let resutingViewController = viewController.tableView.dataSource as? UIViewController
  
//    let resutingViewController = ViewController()
    XCTAssertEqual(resutingViewController, viewController)
  }
  
//  NEVER FAILS!!
//  Mock the network requester and test that the table view gets populated from the network request.
  func test_tableViewPopulatedFromNetworkRequest() {
    
    let viewController = UIApplication.shared.windows[0].rootViewController as! ViewController
    XCTAssertNotNil(viewController.view)
    
    mockPokemonRequest.getAllPokemons { (pokemons, error) in
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
      XCTAssertTrue(tableRows < 0)

    }
    
  }
  
//  Test that it calls the networker with the correct URL.
//  Pass it an endpoint and test that it builds a valid URL.
  func test_buildURLReturnsCorrectURL() {
    let networkManager: NetworkerType = NetworkManager()
    
    let pokemonAPI = PokemonAPIRequest(networker: networkManager)
    let pokemonURL = pokemonAPI.buildURL(endpoint: "pokemon")
    XCTAssertEqual(pokemonURL?.absoluteString, "https://pokeapi.co/api/v2/pokemon")
  }
  
//  test valid data
  func test_pokemonsFromResultsNameAndURLValid() {
    
    let expectation = XCTestExpectation(description: "download pokemons")
    pokemonRequest.getAllPokemons { (pokemons, error) in
//      if let error = error {
//        print("Error: \(error)")
//        XCTFail()
//      }
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        XCTFail()
        return
      }
      print("Pokemon Name: " + pokemons[0].name)
      print("Pokemon Name: " + pokemons[0].url)
      XCTAssertEqual(pokemons[0].name, "bulbasaur")
      XCTAssertEqual(pokemons[0].url, "https://pokeapi.co/api/v2/pokemon/1/")

      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10.0)
//    { (error) in
//      if let error = error {
//        print(error)
//      }
//    }
  }
  
//  test invalid data
//  Test that it calls the networker with the incorrect URL.
  func test_pokemonsFromResultsNameAndURLInValid() {
    
    let expectation = XCTestExpectation(description: "download pokemons")
    pokemonRequest.getAllPokemons { (pokemons, error) in
      //      if let error = error {
      //        print("Error: \(error)")
      //        XCTFail()
      //      }
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        XCTFail()
        return
      }
      print("Pokemon Name: " + pokemons[0].name)
      print("Pokemon Name: " + pokemons[0].url)
      XCTAssertNotEqual(pokemons[0].name, "b")
      XCTAssertNotEqual(pokemons[0].url, "https:///api/v2/pokemon/1/")
      
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 10.0)
    //    { (error) in
    //      if let error = error {
    //        print(error)
    //      }
    //    }
  }

  
  //  NEVER FAILS!!
  //  Have the mock networker return valid data and test that the getAllPokémons method was successful
  func test_pokemonsFromMockNetworkerResultsNameAndURLValid() {
    
//    let expectation = XCTestExpectation(description: "download pokemons")
    mockPokemonRequest.getAllPokemons { (pokemons, error) in
      //      if let error = error {
      //        print("Error: \(error)")
      //        XCTFail()
      //      }
      guard let pokemons = pokemons else {
        print("Error getting pokemon")
        XCTFail()
        return
      }
      print("Pokemon Name: " + pokemons[0].name)
      print("Pokemon Name: " + pokemons[0].url)
      XCTAssertEqual(pokemons[0].name, "b")
      XCTAssertEqual(pokemons[0].url, "https://pokeapi.co/api/v2/pokemon/1/")
      
//      expectation.fulfill()
    }
    
//    wait(for: [expectation], timeout: 10.0)
    //    { (error) in
    //      if let error = error {
    //        print(error)
    //      }
    //    }
  }
//    func test_pokemonsFromResultsUrlValid() {
//      //    guard let result = try! pokémonRequest.jsonObject(fromData: data) as? [String: String] else {
//      pokemonRequest.getAllPokemons { (pokemons, error) in
//        if let error = error {
//          print("Error: \(error)")
//        }
//        guard let pokemons = pokemons else {
//          print("Error getting pokemon")
//          return
//        }
//
//        XCTAssertEqual(pokemons[0].url, "https://pokeapi.co/api/v2/pokemon/1/")
//
//      }
//  }
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
