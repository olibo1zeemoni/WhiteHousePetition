//
//  NetworkController.swift
//  WhiteHousePetition
//
//  Created by Olibo moni on 09/02/2022.
//

import UIKit

class NetworkController{
    static let shared = NetworkController()
    
    
    func fetchPetition(urlString: String)async throws -> [Petition]{
            
            
        
        guard let url = URL(string: urlString) else { throw DataError.brokenURL}
//        guard let data = try? Data(contentsOf: url) else { throw DataError.dataNotFound }
//
//        let decoder = JSONDecoder()
//        guard let jsonPetitions = try? decoder.decode(Petitions.self, from: data) else { throw DataError.dataNotFound}
//        return jsonPetitions.results
        
//        let urlComponents = URLComponents(string: urlString)!
//        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        let (data,response) = try await URLSession.shared.data(from: url )
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw DataError.dataNotFound}
        
        guard let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: data) else { throw DataError.dataNotFound}
        return jsonPetitions.results
}
    
    enum DataError: Error, LocalizedError{
        case dataNotFound
        case brokenURL
    }

}
