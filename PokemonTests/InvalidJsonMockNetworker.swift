//
//  MockNetworker.swift
//  PokemonTests
//
//  Created by KevinT on 2018-03-22.
//  Copyright © 2018 lighthouse-labs. All rights reserved.
//

import UIKit
@testable import Pokemon

class InvalidJsonMockNetworker: NetworkerType {
  func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void){
    //    let filepath = Bundle.main.path(forResource: "pokemon", ofType: "json")
    //    do {
    //      let contents = try String(contentsOfFile: filepath!)
    //      print(contents)
    //    } catch  {
    //      return
    //    }
    guard let path = Bundle.main.path(forResource: "pokemoninvalid", ofType: "json") else {
      return
    }
    let contents = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
    print(contents!)
    
  }
  
}


