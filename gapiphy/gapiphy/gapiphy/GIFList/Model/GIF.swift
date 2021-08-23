//
//  GIF.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation

struct GIF: Codable, Hashable {
    let type: String
    let id: String
    let url: String
    let slug: String
    let bitlyGIFURL: String
    let bitlyURL: String
    let embedURL: String
    let username: String
    let source: String
    let title: String
    let rating: String
    let contentURL: String
    let sourceTLD: String
    let sourcePostURL: String
    let isSticker: Int
    let importDatetime: String
    let trendingDatetime: String
    let images: Images
    let user: User?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case url = "url"
        case slug = "slug"
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username = "username"
        case source = "source"
        case title = "title"
        case rating = "rating"
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images = "images"
        case user = "user"
    }
}
