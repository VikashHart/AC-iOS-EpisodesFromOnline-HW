//
//  ShowsModel.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 11/30/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct ShowInfo: Codable {
    let show: Show
}

struct Show: Codable {
    let id: Int
    let name: String
    let rating: RatingWrapper
    let image: ImageWrapper?
}

struct RatingWrapper: Codable {
    let average: Double?
}

struct ImageWrapper: Codable {
    let medium: String?
}
