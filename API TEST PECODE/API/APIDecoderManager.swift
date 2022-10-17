//
//  APIDecoderManager.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import Foundation

class APIDecoderManager {
    
    let apiNetworkManager = APINetworkManager()
    
    func decodeData(urlString: String, response: @escaping (APIModel?) -> Void ) {
        apiNetworkManager.getData(apiUrl: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let articles = try JSONDecoder().decode(APIModel.self, from: data)
                    response(articles)
                } catch let jsonError {
                    print("Failde to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Some erorr: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
