//
//  GiphyAPI.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation
import Combine

protocol GIFProvider {
    func getTrending(offset: Int?, completion: @escaping (MultipleGIFResponse) -> Void)
    func getSearch(withText text: String, offset: Int?, completion: @escaping (MultipleGIFResponse) -> Void)
}

class GiphyAPI: GIFProvider {
    
    let baseURL = "https://api.giphy.com"
    let apiKey = ""
    
    var cancellable: AnyCancellable?
    
    func getTrending(offset: Int?, completion: @escaping (MultipleGIFResponse) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/v1/gifs/trending")
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MultipleGIFResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { response in
                completion(response)
            })
    }
    
    func getSearch(withText text: String, offset: Int?, completion: @escaping (MultipleGIFResponse) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/v1/gifs/search")
        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: text)
        ]
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MultipleGIFResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { response in
                completion(response)
            })
    }
    
}
