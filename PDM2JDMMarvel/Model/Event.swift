//
//  model.swift
//  Marvel Comics
//
//  Created by JDM on 07/12/2022.
//

import Foundation

// MARK: - Welcome8
struct EventsResponse: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: ResultsPage
}

// MARK: - DataClass
class ResultsPage: Codable {
    let offset, limit, total, count: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let title, description: String
    let resourceURI: String
    let urls: [URLElement]
    let modified: String
    let start, end: String?
    let thumbnail: Thumbnail
    let creators: ItemCollection
    let characters: ItemCollection
    let stories: ItemCollection
    let comics, series: ItemCollection
    let next, previous: Item!
    
}

// MARK: - ItemCollection
struct ItemCollection: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

// MARK: - Item
struct Item: Codable {
    let resourceURI: String
    let name: String
    let role: String?
    let type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
// MARK: - URLElement
struct URLElement: Codable  {
    let type: URLType
    let url: String
}

enum URLType: String, Codable  {
    case detail = "detail"
    case wiki = "wiki"
}
