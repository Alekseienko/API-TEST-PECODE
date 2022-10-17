//
//  APIModel.swift
//  API TEST PECODE
//
//  Created by alekseienko on 14.10.2022.
//

import Foundation
// MARK: - APIModel
struct APIModel: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]
}
// MARK: - Article
struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String?
}
