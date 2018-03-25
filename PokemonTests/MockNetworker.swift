//
//  MockNetworker.swift
//  PokemonTests
//
//  Created by KevinT on 2018-03-22.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import UIKit
@testable import Pokemon

enum MockNetworkerError: Swift.Error {
  case NoFile
}

class MockNetworker: NetworkerType {
  func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void){
    
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.path(forResource: "pokemon", ofType: "json")
    let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    completionHandler(data!, nil, MockNetworkerError.NoFile)

  }

}

