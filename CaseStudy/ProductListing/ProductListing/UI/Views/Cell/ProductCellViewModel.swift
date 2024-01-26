//
//  ProductCellViewModel.swift
//  ProductListing
//
//  Created by Koray Yıldız on 18.09.22.
//

import Foundation

protocol ProductCellViewModelDelegate {
    func minusButtonTapped(at indexPath: IndexPath)
    func plusButtonTapped(at indexPath: IndexPath)
}

final class ProductCellViewModel {

    private var counter: Int = .zero {
        didSet {
            viewDelegate.updateCounterLabel(text: counter.string)
        }
    }

    private let viewDelegate: ProductCellViewDelegate
    private var presentation: ProductPresentation
    private let delegate: ProductCellViewModelDelegate

    init(viewDelegate: ProductCellViewDelegate, presentation: ProductPresentation, delegate: ProductCellViewModelDelegate) {
        self.viewDelegate = viewDelegate
        self.presentation = presentation
        self.delegate = delegate
    }

    func load() {
        viewDelegate.configure(presentation: presentation)
    }

    func plusButtonTapped() {
        presentation.counter = presentation.counter.forward
        counter = counter.forward
//        itemCountDidChange?()
        delegate.plusButtonTapped(at: viewDelegate.indexPath)
    }

    func minusButtonTapped() {
        guard presentation.counter.isNotZero else { return }
        counter = counter.backward
        presentation.counter = presentation.counter.backward
//        itemCountDidChange?()
        delegate.minusButtonTapped(at: viewDelegate.indexPath)
    }
}

// MARK: - Int
fileprivate extension Int {
    var string: String {
        return String(self)
    }

    var forward: Int {
        return self + 1
    }

    var backward: Int {
        return self - 1
    }

    var isZero: Bool {
        return self == .zero
    }

    var isNotZero: Bool {
        return !isZero
    }
}
