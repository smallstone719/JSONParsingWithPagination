//
//  Photo.swift
//  JSONParsingWithPagination
//
//  Created by Thach Nguyen Trong on 3/22/24.
//

import SwiftUI

struct Photo: Identifiable, Codable, Hashable {
    let id, author: String
    let width, height: Int
    let url, downloadURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURLString = "download_url"
    }
    
    var downloadURL: URL? {
        return URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        return URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
    
}
