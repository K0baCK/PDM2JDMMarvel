//
//  api.swift
//  PDM2-Project
//
//  Created by Miguel Carvalho on 15/12/2022.
//

import Foundation

class MarvelEvents {
    static let API_URL = "https://gateway.marvel.com/v1/public/"
    static let apikey = "d8a4904230f10438b19df16a51332c6d"
    static let hash = "30b4d4c43515f8753dc16aba0e1eea86"
    static let id = ""
    static let ts = 1
    
    static func fetchAllComics (completionHandler: @escaping
                                (ResultsPage) -> Void ) {
        let urlString = "\(API_URL)events?apikey=\(apikey)&hash=\(hash)&ts=\(ts)"
        if let url = URL.init(string:  urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let retrievedData = data else {
                    print("nao deu lol")
                    return
                }
                if let event = try?
                    JSONDecoder().decode(EventsResponse.self, from: retrievedData) {
                    completionHandler(event.data)
                    print("Connected to Marvel API successfully")
                } else {
                    print("Error while parsind data")
                }
            })
            task.resume()
        }
    }
}
