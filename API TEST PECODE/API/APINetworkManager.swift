//
//  APINetworkManager.swift
//  API TEST PECODE
//
//  Created by alekseienko on 14.10.2022.
//
//9f05653438f24480ad395bef6ac8a3ae apiKey1
//4eaddc397dff4f98beb748e4f953edcc apiKey2
//853b8dfddc0446d2aae6567ed86acfc0 apiKey3
import Foundation

class APINetworkManager {
    
    let apiKey = "&apiKey=435122dd2e384d33b95f41c8a0f00403"
    let apiService = "https://newsapi.org/v2/top-headlines?"
    var apiRequest = "country=ua"
    var apiCurrentUrl = ""
    
    func getData(apiUrl: String, page: Int, pageSize: Int, completion: @escaping (Result<Data,Error>) -> Void) {
        guard var urlComponents = URLComponents(string: apiUrl) else {
            print("Some problem with API URL")
            return
        }
        urlComponents.queryItems! += [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "pageSize", value: String(pageSize))]
        let request = URLRequest(url:urlComponents.url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                completion(.success(data))
            }
        }.resume()
    }
}


