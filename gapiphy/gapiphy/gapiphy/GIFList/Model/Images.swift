//
//  Images.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation

struct Images: Codable, Hashable {
    let original: Original
    let fixedHeightSmall: Fixed?

    enum CodingKeys: String, CodingKey {
        case original = "original"
        case fixedHeightSmall = "fixed_height_small"
    }
}

struct Original: Codable, Hashable {
    let height: String
    let width: String
    let size: String
    let frames: String
    let url: String
    let mp4Size: String
    let mp4: String

    enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case size = "size"
        case frames = "frames"
        case url = "url"
        case mp4Size = "mp4_size"
        case mp4 = "mp4"
    }
}

struct Fixed: Codable, Hashable {
    let height: String
    let width: String
    let size: String
    let url: String
    let mp4Size: String
    let mp4: String
    let webpSize: String
    let webp: String

    enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case size = "size"
        case url = "url"
        case mp4Size = "mp4_size"
        case mp4 = "mp4"
        case webpSize = "webp_size"
        case webp = "webp"
    }
}
