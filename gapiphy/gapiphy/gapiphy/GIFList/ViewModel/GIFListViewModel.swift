//
//  GIFListViewModel.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation
import Combine

class GIFListViewModel {
    
    let gifProvider: GIFProvider
    
    let recentSearchManager: RecentSearchManager
    
    @Published var gifs = [GIF]()
    
    @Published var recentSearches: [String]
    
    @Published var maxSearch: Int
    
    @Published var isLoading = false
    
    var total: Int = 0
    
    var isSearching = false
    
    var searchText: String?
    
    init(gifProvider: GIFProvider = GiphyAPI(), recentSearchManager: RecentSearchManager = RecentSearchManager()) {
        self.gifProvider = gifProvider
        self.recentSearchManager = recentSearchManager
        recentSearches = recentSearchManager.savedSearches
        maxSearch = recentSearchManager.maxSavedSearches
    }
    
    func searchGifs(withText text: String) {
        recentSearchManager.addSearch(text)
        updateSearchValues()
        gifs.removeAll()
        isSearching = true
        searchText = text
        getGifsIfNeeded()
    }
    
    func finishSearch() {
        guard isSearching else {
            return
        }
        gifs.removeAll()
        isSearching = false
        searchText = nil
        getGifsIfNeeded()
    }
    
    func getGifsIfNeeded() {
        guard !isLoading else {
            return
        }
        if gifs.count == 0 || gifs.count < total {
            if isSearching {
                requestGifSearch()
            } else {
                requestTrendingGifs()
            }
        }
    }
    
    func requestTrendingGifs() {
        isLoading = true
        gifProvider.getTrending(offset: gifs.count) { response in
            self.gifs.append(contentsOf: response.data)
            self.total = response.pagination.totalCount
            self.isLoading = false
        }
    }
    
    func requestGifSearch() {
        guard let text = searchText else {
            return
        }
        isLoading = true
        gifProvider.getSearch(withText: text, offset: gifs.count) { response in
            self.gifs.append(contentsOf: response.data)
            self.total = response.pagination.totalCount
            self.isLoading = false
        }
    }
    
    private func updateSearchValues() {
        recentSearches = recentSearchManager.savedSearches
        maxSearch = recentSearchManager.maxSavedSearches
    }
    
    func updateMaxSearch(_ value: Int) {
        recentSearchManager.maxSavedSearches = value
        updateSearchValues()
    }
    
}
