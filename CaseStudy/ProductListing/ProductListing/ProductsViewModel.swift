//
//  ProductsViewModel.swift
//  ProductListing
//
//  Created by Koray Yıldız on 17.09.22.
//

import Foundation
import Networker

struct CheckoutPresentation {
    let category: String
    let products: [ProductPresentation]
}

final class ProductsViewModel {

    private(set) var presentation: ProductsListingPresentation = ProductsListingPresentation(products: []) {
        didSet {
            viewDelegate.reloadData()
        }
    }

    private var selectedProducts: [ProductPresentation] = []

    private let service: RestService
    private unowned var viewDelegate: ProductsViewDelegate

    var cellDelegate: ProductCellViewModelDelegate {
        return self
    }

    init(viewDelegate: ProductsViewDelegate, service: RestService) {
        self.viewDelegate = viewDelegate
        self.service = service
    }

    func fetchProducts() {
        Task { @MainActor in
            do {
                let response = try await service.execute(operation: GetProductsTask(), type: [Product].self)
                presentation = ProductsListingPresentation(products: response)
            }
            catch let error {

            }
        }
    }
}

// MARK: - ProductCellViewModelDelegate
extension ProductsViewModel: ProductCellViewModelDelegate {
    func minusButtonTapped(at indexPath: IndexPath) {
        let buttonTitle = "Checkout (\(presentation.basketItemCount))"
        viewDelegate.setCheckoutButtonTitle(text: buttonTitle)

        let formatedPrice = presentation.productList[indexPath.section].categoryTotalPrice.formattedPrice
        viewDelegate.configureSectionHeaderPriceLabel(at: indexPath, with: formatedPrice)

        selectedProducts.removeLast()
    }

    func plusButtonTapped(at indexPath: IndexPath) {
        let buttonTitle = "Checkout (\(presentation.basketItemCount))"
        viewDelegate.setCheckoutButtonTitle(text: buttonTitle)

        let formatedPrice = presentation.productList[indexPath.section].categoryTotalPrice.formattedPrice
        viewDelegate.configureSectionHeaderPriceLabel(at: indexPath, with: formatedPrice)

        let product = presentation.productList[indexPath.section].products[indexPath.row]
        selectedProducts.append(product)
    }
}
