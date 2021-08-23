//
//  GiphyAPIResponseModel.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation

struct MultipleGIFResponse: Codable {
    let data: [GIF]
    let pagination: Pagination
}

struct Pagination: Codable {
    let offset: Int
    let totalCount: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case totalCount = "total_count"
        case count = "count"
    }
}
