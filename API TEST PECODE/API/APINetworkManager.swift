//
//  APINetworkManager.swift
//  API TEST PECODE
//
//  Created by alekseienko on 14.10.2022.
//

import Foundation

class APINetworkManager {
    
    func getData(apiUrl: String, comoletion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Some problem with API URL")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    comoletion(.failure(error))
                    return
                }
                guard let data = data else {return}
                comoletion(.success(data))
            }
        }.resume()
    }
}
