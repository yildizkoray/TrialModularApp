//
//  ProductsCategoryHeaderView.swift
//  ProductListing
//
//  Created by Koray Yıldız on 16.09.22.
//

import UIKit
import SnapKit

final class ProductsCategoryHeaderView: UITableViewHeaderFooterView {

    static let identifier = String(describing: ProductsCategoryHeaderView.self)

    private lazy var categoryHeaderView = CategoryView(frame: .zero)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(categoryHeaderView)
        categoryHeaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        categoryHeaderView.configureNameLabel(with: text)
    }

    func configurePriceLabel(with text: String) {
        categoryHeaderView.configureTotalPriceLabel(with: text)
    }
}
