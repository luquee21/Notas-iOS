//
//  Image.swift
//  proyecto
//
//  Created by macOS on 24/5/21.
//

import Foundation

// MARK: - Image
struct ImageModel: Codable {
    var status: String?
    var result: [ImageModelString]?
}

// MARK: - Result
struct ImageModelString: Codable {
    var photo: String
    var date: String
}
