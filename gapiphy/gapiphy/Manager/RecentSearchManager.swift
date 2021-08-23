//
//  RecentSearchManager.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import Foundation

class RecentSearchManager {
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    var maxSavedSearches: Int {
        get {
            let maxSavedSearches = defaults.integer(forKey: "maxSavedSearches")
            return maxSavedSearches == 0 ? 5 : maxSavedSearches
        }
        
        set {
            if newValue < savedSearches.count {
                savedSearches = savedSearches.reversed()
                    .dropLast(savedSearches.count - newValue)
                    .reversed()
            }
            defaults.setValue(newValue, forKey: "maxSavedSearches")
        }
    }
    
    var savedSearches: [String] {
        get {
            guard let joinedSavedSearches = defaults.string(forKey: "savedSearches") else {
                return []
            }
            let splitSavedSearches = joinedSavedSearches.split(separator: "|")
                .reversed()
                .compactMap { String($0) }
            return splitSavedSearches
        }
        
        set {
            let joinedSearches = newValue.joined(separator: "|")
            defaults.setValue(joinedSearches, forKey: "savedSearches")
        }
    }
    
    func addSearch(_ text: String) {
        var searches = savedSearches
        if searches.isEmpty {
            savedSearches = [text]
        } else {
            guard !searches.contains(text) else {
                return
            }
            if searches.count == maxSavedSearches {
                searches.removeFirst()
            }
            searches.append(text)
            savedSearches = searches
        }
    }
    
    
}
