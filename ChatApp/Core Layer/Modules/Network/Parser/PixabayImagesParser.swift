//
//  PixabayImagesParser.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

struct PixabayApiModel: Codable {
    let hits: [PixabayImage]?
}

struct PixabayImage: Codable {
    let id: Int?
    let previewURL: String?
    let webformatURL: String?
    let largeImageURL: String?
    let fullHDURLL: String?
    let imageURL: String?
}

class PixabayImagesParser: IParser {
    typealias Model = [PixabayImage]
    
    func parse(data: Data) -> [PixabayImage]? {
        do {
            let pixabay = try JSONDecoder().decode(PixabayApiModel.self, from: data)
            return pixabay.hits
        } catch {
            return nil
        }
    }
}
