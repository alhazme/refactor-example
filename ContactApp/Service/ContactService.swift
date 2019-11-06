//
//  ContactService.swift
//  ContactApp
//
//  Created by Mochamad Fariz Al Hazmi on 06/11/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

// Represent Error Type
enum ContactServiceError: Error {
    case missingData
}

// Contract
protocol ContactService {
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void)
}

class NetworkContactService: ContactService {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    // @escaping (Result<[Contact], Error>) -> Void = callback function
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void) {
        let url = URL(string: "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/e3ea7cf52a7de7872863f9b2350f2c434eb0fe2c/contacts.json")!
        let task = URLSession.shared.dataTask(with: url) { [jsonDecoder] (data, response, error) in
            if let theError = error {
                // do something with error
                completion(.failure(theError))
                return
            }
            
            guard let theData = data else {
                // do something when data is null
                completion(.failure(ContactServiceError.missingData))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(ContactListResponse.self, from: theData)
                let contacts = response.data

                completion(.success(contacts))
            } catch (let decodeError) {
                completion(.failure(decodeError))
                // do something when failed response mapping
            }
        }
        
        task.resume()
    }
    
}
