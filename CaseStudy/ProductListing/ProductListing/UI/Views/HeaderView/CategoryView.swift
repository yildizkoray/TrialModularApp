//
//  CategoryView.swift
//  ProductListing
//
//  Created by Koray Yıldız on 17.09.22.
//

import UIKit

final class CategoryView: UIView {

    private lazy var containerStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [topSeparatorView, labelsContainerStackView, bottomSeparatorView])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var topSeparatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var bottomSeparatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var labelsContainerStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [categoryNameLabel, categoryTotalPriceLabel])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 24
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 10)
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var categoryNameLabel: UILabel = {
        var label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var categoryTotalPriceLabel: UILabel = {
        var label = UILabel()
        label.text = Float(0.0).formattedPrice
        label.textAlignment = .center
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        configureConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        addSubview(containerStackView)
    }

    private func configureConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        [topSeparatorView, bottomSeparatorView].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
    }

    func configureNameLabel(with text: String) {
        categoryNameLabel.text = text
    }

    func configureTotalPriceLabel(with text: String) {
        categoryTotalPriceLabel.text = text
    }
}

// MARK: - NumberFormatter

public extension NumberFormatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyDecimalSeparator = "."
        return formatter
    }()
}


public extension Float {

    var ns: NSNumber {
        return NSNumber(value: self)
    }

    var formattedPrice: String {
        let formatter: NumberFormatter = .priceFormatter
        return formatter.string(from: self.ns) ?? ""
    }
}

// MARK: - Double + Optional

public extension Optional where Wrapped == Float {

    var formattedPrice: String? {
        let formatter: NumberFormatter = .priceFormatter
        guard self != nil, self != .zero else { return nil }
        return formatter.string(from: self!.ns)
    }
}


