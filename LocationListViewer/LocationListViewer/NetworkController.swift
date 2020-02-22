//
//  NetworkController.swift
//  LocationListViewer
//
//  Created by morse on 2/21/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case badData
    case badResponse
    case otherError
}

class NetworkController {
    
    func fetchAThing() {
        let url = thingURL()
        fetch(from: url) { result in
            switch result {
            case .failure(let error):
                #warning("Deal with failure to receive data error")
                print(error)
            case .success(let data):
                let possibleThing: String? = self.decode(data: data)
                guard let thing = possibleThing else {
                    #warning("Deal with possibleThing being nil")
                    return
                }
                #warning("Do something with thing (store in CoreData or return to caller)")
                print(thing)
            }
        }
    }
    
    func fetch(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(FetchError.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(FetchError.badData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    func decode<T: Codable>(data: Data) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(T.self, from: data)
            return decoded
        } catch {
            #warning("Deal with decoding error here")
            print(error)
            return nil
        }
    }
    
    func thingURL() -> URL {
        
        return URL(string: "")!
    }
}
