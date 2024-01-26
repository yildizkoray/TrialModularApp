//
//  ProductCell.swift
//  ProductListing
//
//  Created by Koray Yıldız on 16.09.22.
//

import Foundation
import UIKit

protocol ProductCellViewDelegate: AnyObject {
    var indexPath: IndexPath { get }

    func configure(presentation: ProductPresentation)
    func updateCounterLabel(text: String)
}

final class ProductCell: UITableViewCell {

    static let identifier = String(describing: ProductCell.self)

    private var counter: Int = .zero

    var viewModel: ProductCellViewModel! {
        didSet {
            viewModel.load()
        }
    }

    private lazy var buttonsContainerStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel, minusButton, counterLabel, plusButton])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var counterLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        return label
    }()

    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var plusButton: UIButton = {
        var button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var minusButton: UIButton = {
        var button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(buttonsContainerStackView)
        buttonsContainerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        plusButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(32)
        }

        minusButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func plusButtonTapped() {
        viewModel.plusButtonTapped()
    }

    @objc private func minusButtonTapped() {
        viewModel.minusButtonTapped()
    }
}

// MARK: - ProductCellViewDelegate
extension ProductCell: ProductCellViewDelegate {
    var indexPath: IndexPath {
        return (superview as? UITableView)?.indexPath(for: self) ?? IndexPath(row: .zero, section: .zero)
    }

    func configure(presentation: ProductPresentation) {
        nameLabel.text = presentation.name
        priceLabel.text = presentation.price.formattedPrice
    }

    func updateCounterLabel(text: String) {
        counterLabel.text = text
    }
}
