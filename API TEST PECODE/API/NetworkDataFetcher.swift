//
//  NetworkDataFetcher.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import Foundation

class NetworkDataFetcher {
    
    let apiNetworkManager = APINetworkManager()
    
    func decodeData(urlString: String, page: Int, pageSize: Int, response: @escaping ([Article]?) -> Void ) {
                    
        apiNetworkManager.getData(apiUrl: urlString , page: page, pageSize: pageSize) { (result) in
            switch result {
            case .success(let data):
                do {
                    let articles = try JSONDecoder().decode(APIModel.self, from: data)
                    response(articles.articles)
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
