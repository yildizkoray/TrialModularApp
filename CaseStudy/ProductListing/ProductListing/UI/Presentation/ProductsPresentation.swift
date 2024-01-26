//
//  ProductsPresentation.swift
//  ProductListing
//
//  Created by Koray Yıldız on 17.09.22.
//

import Foundation

class ProductsListingPresentation {
    private(set) var productList: [ProductsPresentation]

    var basketItemCount: Int {
        return productList.map { $0.categoryTotalProductCount }.reduce(0, +)
    }

    init(products: [Product]) {
        self.productList = []
        let groupedProducts = Dictionary(grouping: products, by: { $0.type })

        groupedProducts.forEach { key, value in
            self.productList.append(
                ProductsPresentation(category: key.rawValue.capitalized, products: value)
            )
        }
    }
}

class ProductsPresentation {
    let category: String
    let products: [ProductPresentation]

    var categoryTotalPrice: Float {
        return products.map { $0.totalPrice }.reduce(0, +)
    }

    var categoryTotalProductCount: Int {
        return products.map { $0.counter }.reduce(0, +)
    }

    init(category: String, products: [ProductPresentation]) {
        self.category =  category
        self.products = products
    }

    init(category: String, products: [Product]) {
        self.category =  category
        self.products = products.lazy.map({ product in
            return ProductPresentation(id: product.id, name: product.name, price: product.price, type: product.type)
        })
    }
}

final class ProductPresentation {
    let id: Int
    let name: String
    let price: Float
    let type: Category
    var counter: Int = .zero

    var totalPrice: Float {
        return price * Float(counter)
    }

    init(id: Int, name: String, price: Float, type: Category) {
        self.id = id
        self.name = name
        self.price = price
        self.type = type
    }
}
