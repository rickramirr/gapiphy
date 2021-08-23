//
//  User.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import Foundation

struct User: Codable, Hashable {
    let avatarURL: String
    let bannerImage: String
    let bannerURL: String
    let profileURL: String
    let username: String
    let displayName: String
    let userDescription: String
    let instagramURL: String
    let websiteURL: String
    let isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username = "username"
        case displayName = "display_name"
        case userDescription = "description"
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
}
