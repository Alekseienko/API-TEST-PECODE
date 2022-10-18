//
//  APINetworkManager.swift
//  API TEST PECODE
//
//  Created by alekseienko on 14.10.2022.
//
//9f05653438f24480ad395bef6ac8a3ae apiKey1
//4eaddc397dff4f98beb748e4f953edcc apiKey2
//853b8dfddc0446d2aae6567ed86acfc0 apiKey3

//https://newsapi.org/v2/ everything?q= bitcoin              &apiKey=853b8dfddc0446d2aae6567ed86acfc

//https://newsapi.org/v2/ top-headlines?country= us          &apiKey=853b8dfddc0446d2aae6567ed86acfc0
//https://newsapi.org/v2/ top-headlines?sources= bbc-news    &apiKey=853b8dfddc0446d2aae6567ed86acfc0
//https://newsapi.org/v2/ top-headlines?category= general    &apiKey=853b8dfddc0446d2aae6567ed86acfc0

import Foundation

class APINetworkManager {
    
    let apiKey = "&apiKey=9f05653438f24480ad395bef6ac8a3ae"
    let apiService = "https://newsapi.org/v2/"
    var apiRequest = "top-headlines?country=ua"
    var lastURL = ""
    
    func getData(request: String, page: Int, pageSize: Int, completion: @escaping (Result<Data,Error>) -> Void) {
        
        var url = apiService + request + apiKey
        if request == lastURL {
            url = request
        }
        
        guard var urlComponents = URLComponents(string: url) else {
            print("Some problem with API URL")
            return
        }
        lastURL = url
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


