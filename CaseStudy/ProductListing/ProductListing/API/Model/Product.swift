//
//  Product.swift
//  ProductListing
//
//  Created by Koray Yıldız on 17.09.22.
//

import Foundation

enum Category: String, Decodable {
    case meat = "meat"
    case dairy = "dairy"
    case fruit = "fruit"
}

struct Product: Decodable {
    let id: Int
    let name: String
    let price: Float
    let type: Category
}
